import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../enums/BetPredictionStatus.dart';
import '../enums/BetPredictionType.dart';
import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../enums/MatchEventStatusMore.dart';
import '../helper/SharedPrefs.dart';
import 'Score.dart';
import 'Team.dart';
import 'TimeDetails.dart';
import 'UserPrediction.dart';
import 'constants/JsonConstants.dart';
import 'constants/MatchConstants.dart';

class MatchEvent implements Comparable<MatchEvent>{


  MatchEvent({
    required this.eventId,
		required this.leagueId,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.status_more,
		required this.start_at
  } );


  Map<String, String> ?translations;

  int eventId;

  int leagueId;

  String display_status = Constants.empty;

	String start_at;

	String start_at_local = Constants.empty;

  String status;

  int startMillis = 0;

  String status_more;

  Team homeTeam ;

  Score homeTeamScore = Score.def();

  Team awayTeam;

  Score awayTeamScore = Score.def();

  MatchOdds? odds;

  ChangeEvent ?changeEvent;

  TimeDetails? timeDetails;

  // the last period of the match e.g. extra_2 means the match ended in extra time.
  String? lasted_period;

  //winner code based on Score.aggregatedScore , i.e. the winner or qualified team.
  int? aggregated_winner_code;

  //the match winner code after all played periods. counts extra time and penalties.
	// 3 = X
  int? winner_code;

  bool isFavourite = false;

	String calculateLiveMinute(BuildContext context, DateTime startLocal) {

		if (! (MatchEventStatus.INPROGRESS.statusStr == status)) {
			return 'error not inprog';
		}

		if (status_more.isEmpty){
			return 'no st more';
		}

		if (MatchEventStatusMore.INPROGRESS_HALFTIME_EXTRA.statusStr == status_more) {
			return AppLocalizations.of(context)!.status_half_time_et;
		}

		if (MatchEventStatusMore.INPROGRESS_HALFTIME.statusStr == status_more ) {
			if (ChangeEvent.SECOND_HALF_START == changeEvent){
				changeEvent = ChangeEvent.NONE;
				return '46';
			}

			return AppLocalizations.of(context)!.status_half_time;
		}

	 if (MatchEventStatusMore.INPROGRESS_1ST_HALF.statusStr == status_more) {

			int x = DateTime.now().millisecondsSinceEpoch - startLocal.millisecondsSinceEpoch;
			int minute = x ~/ 60000;
			if (minute > 45) {
				String injury1st = Constants.empty;
				if (minute - 45 >0){
					injury1st = (minute - 45).toString();
				}

				return "45+$injury1st";
			}

			return "$minute'";

		}

	 	if (MatchEventStatusMore.INPROGRESS_2ND_HALF.statusStr == status_more) {

	 		int firstHalfMinutes = 45;

			int millisecondsSinceMatchStart = DateTime.now()
					.millisecondsSinceEpoch - startLocal.millisecondsSinceEpoch;

			int minute = firstHalfMinutes + (millisecondsSinceMatchStart ~/ 60000) ;// - 15; // 15 is for half time break

			if (minute > 90) {
				String injury2nd = (minute - 90).toString();//90).toString();
				return "90+$injury2nd";
			}

			return "$minute'";

		}

	 	if (MatchEventStatusMore.INPROGRESS_1ST_EXTRA.statusStr == status_more) {// TODO:  extra time etc
		 int firstMinutes = 90;

		 int millisecondsSinceMatchStart = DateTime
				 .now()
				 .millisecondsSinceEpoch - startLocal.millisecondsSinceEpoch;

		 int minute = firstMinutes + (millisecondsSinceMatchStart ~/ 60000);// - 15; // 15 is for half time break

		 if (minute > 105){// 90) {
			 String injury2nd = (minute - 15).toString();//90).toString();
			 return  "${AppLocalizations.of(context)!.status_more_et} 105+$injury2nd";
		 }

		 return "${AppLocalizations.of(context)!.status_more_et} $minute'";

		}

	 	if (MatchEventStatusMore.INPROGRESS_2ND_EXTRA.statusStr == status_more) {// TODO:  extra time etc
		 int firstMinutes = 105;

		 int millisecondsSinceMatchStart = DateTime
				 .now()
				 .millisecondsSinceEpoch - startLocal.millisecondsSinceEpoch;

		 int minute = firstMinutes + (millisecondsSinceMatchStart ~/ 60000);// - 15; // 15 is for half time break

		 if (minute > 120){// 90) {
			 String injury2nd = (minute - 15).toString();//90).toString();
			 return "${AppLocalizations.of(context)!.status_more_et} 120+$injury2nd";
		 }

		 return "${AppLocalizations.of(context)!.status_more_et} $minute'";

	 }

	 	if (MatchEventStatusMore.INPROGRESS_PENALTIES.statusStr == status_more) {
			return AppLocalizations.of(context)!.status_more_pen;
	 }

	 	return '??' + status_more;
	}

	@override
	operator == (other) =>
			other is MatchEvent &&
					other.eventId == eventId ;

	@override
	int get hashCode => eventId * 37;

	@override
	int compareTo(MatchEvent other){
		if (startMillis > other.startMillis){
			return 1;
		}

		if (startMillis < other.startMillis){
			return -1;
		}

		if (eventId > other.eventId){
			return -1;
		}

		return 1;

	}

	static Future<MatchEvent> eventFromJson(var event) async{

		var homeTeam = event["home_team"];
		var awayTeam = event["away_team"];
		var homeTeamScore = event["home_score"];
		var awayTeamScore = event["away_score"];
		var _changeEvent = event["changeEvent"] as int;
		int? sportId = event['sportId'];
		sportId ??= 1;


		Team hTeam = Team.fromJson(homeTeam);
		Team aTeam = Team.fromJson(awayTeam);


		var startAt = event['start_at'];
		MatchEvent match = MatchEvent(eventId: event[JsonConstants.id], leagueId: event[JsonConstants.leagueId], status: event["status"], status_more: event["status_more"]??'-', homeTeam: hTeam, awayTeam: aTeam, start_at: startAt);
		match.changeEvent = ChangeEvent.ofCode(_changeEvent);



		var eventOdds = event["main_odds"];
		if (eventOdds != null) {
			var outcome1 = eventOdds["outcome_1"];
			var outcome1Value = outcome1["value"];

			var outcomeX = eventOdds["outcome_X"];
			var outcomeXValue = outcomeX["value"];

			var outcome2 = eventOdds["outcome_2"];
			var outcome2Value = outcome2["value"];

			MatchOdds odds = MatchOdds(
					oddO25: UserPrediction(eventId: event[JsonConstants.id],
							sportId: sportId,
							homeTeam: hTeam,
							awayTeam: aTeam,
							betPredictionType: BetPredictionType.OVER_25,
							betPredictionStatus: BetPredictionStatus.PENDING,
							value: outcome1Value),
					oddU25: UserPrediction(eventId: event[JsonConstants.id],
							sportId: sportId,
							homeTeam: hTeam,
							awayTeam: aTeam,
							betPredictionType: BetPredictionType.UNDER_25,
							betPredictionStatus: BetPredictionStatus.PENDING,
							value: outcome1Value),
					odd1: UserPrediction(eventId: event[JsonConstants.id],
							sportId: sportId,
							homeTeam: hTeam,
							awayTeam: aTeam,
							betPredictionType: BetPredictionType.HOME_WIN,
							betPredictionStatus: BetPredictionStatus.PENDING,
							value: outcome1Value),
					//.toString().replaceAll(',', '.')),
					oddX: UserPrediction(eventId: event[JsonConstants.id],
							sportId: sportId,
							homeTeam: hTeam,
							awayTeam: aTeam,
							betPredictionType: BetPredictionType.DRAW,
							betPredictionStatus: BetPredictionStatus.PENDING,
							value: outcomeXValue),
					odd2: UserPrediction(eventId: event[JsonConstants.id],
							sportId: sportId,
							homeTeam: hTeam,
							awayTeam: aTeam,
							betPredictionType: BetPredictionType.AWAY_WIN,
							betPredictionStatus: BetPredictionStatus.PENDING,
							value: outcome2Value));

			match.odds = odds;
		}

		if (homeTeamScore != null){
			match.homeTeamScore = Score(homeTeamScore["current"], homeTeamScore["display"], homeTeamScore["normal_time"],
					homeTeamScore["period_1"], homeTeamScore["period_2"]);
		}

		if (awayTeamScore != null){
			match.awayTeamScore = Score(awayTeamScore["current"], awayTeamScore["display"], awayTeamScore["normal_time"],
					awayTeamScore["period_1"], awayTeamScore["period_2"]);
		}

		match.timeDetails = TimeDetails.fromJson(event['time_details']);

		// the last period of the match e.g. extra_2 means the match ended in extra time.
		match.lasted_period = event['lasted_period'];

		//winner code based on Score.aggregatedScore , i.e. the winner or qualified team.
		match.aggregated_winner_code = event['aggregated_winner_code'];

		//the match winner code after all played periods. counts extra time and penalties.
		match.winner_code = event['winner_code'];

		List<String> favEvents = await sharedPrefs.getListByKey(sp_fav_event_ids);
		if (favEvents.contains(match.eventId.toString())){
			match.isFavourite = true;
		}

		// match.calculateLiveMinute();
		return match;
	}

  void copyFrom(MatchEvent incomingEvent) {
  	changeEvent = incomingEvent.changeEvent;
  	if(homeTeam.name.contains('rsenal')){
  		int i=0;
		}


  	homeTeamScore.copyFrom(incomingEvent.homeTeamScore);
  	awayTeamScore.copyFrom(incomingEvent.awayTeamScore);
  	status = incomingEvent.status;
  	status_more = incomingEvent.status_more;
  	timeDetails = incomingEvent.timeDetails;
  	lasted_period = incomingEvent.lasted_period;

	}

	String? calculateNonLiveStatus(BuildContext context){

		if (status_more.isEmpty){
			return 'error non live more';
		}

		//if (MatchEventStatus.FINISHED.statusStr == status){
			if (MatchEventStatusMore.GAME_FINISHED.statusStr == status_more
					|| MatchEventStatusMore.ENDED.statusStr == status_more) {
				return AppLocalizations.of(context)!.status_finished;
			}

			if (MatchEventStatusMore.AFTER_EXTRA_TIME.statusStr == status_more) {
				return AppLocalizations.of(context)!.status_more_after_et;
			}

			if (MatchEventStatusMore.AFTER_PENALTIES.statusStr == status_more) {
				return AppLocalizations.of(context)!.status_more_after_pen;
			}

		// }

		if (MatchEventStatus.CANCELLED.statusStr == status){
			return AppLocalizations.of(context)!.status_cancelled;
		}

		if (MatchEventStatus.INTERRUPTED.statusStr == status){
			return AppLocalizations.of(context)!.status_interrupt;
		}

		if (MatchEventStatus.POSTPONED.statusStr == status){
			return AppLocalizations.of(context)!.status_postponed;
		}

		if (MatchEventStatus.SUSPENDED.statusStr == status){
			return AppLocalizations.of(context)!.status_suspended;
		}

		if (MatchEventStatus.WILL_CONTINUE.statusStr == status){
			return AppLocalizations.of(context)!.status_will_cont;
		}

		if (MatchEventStatus.DELAYED.statusStr == status){
			return AppLocalizations.of(context)!.status_delayed;
		}

		if (MatchEventStatus.NOTSTARTED.statusStr == status){
			return start_at_local;
		}

		return null;

	}

  void calculateDisplayStatus(BuildContext context) {
		DateTime currentPeriodStartTime = calculateCurrentPeriodStartTime();
		String? display = calculateNonLiveStatus(context);

		if (display != null) {
			display_status = display;
			return;
		}


		display_status = calculateLiveMinute(context, currentPeriodStartTime);
	}

  DateTime calculateCurrentPeriodStartTime() {

		DateTime? currentPeriodStartTime;

		if (timeDetails != null && timeDetails!.currentPeriodStartTimestamp > 0){
			currentPeriodStartTime = DateTime.fromMillisecondsSinceEpoch(timeDetails!.currentPeriodStartTimestamp * 1000).toLocal();
		}

		DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);
		DateTime matchTime = matchTimeFormat.parseUtc(start_at).toLocal();
		startMillis = matchTime.millisecondsSinceEpoch;
		start_at_local = '${matchTime.hour < 10 ? '0' : Constants.empty}${matchTime.hour}:${matchTime.minute < 10 ? '0' : Constants.empty}${matchTime.minute}' ;

		if (currentPeriodStartTime == null){
			currentPeriodStartTime = matchTime;
		};

		return currentPeriodStartTime;
	}

}