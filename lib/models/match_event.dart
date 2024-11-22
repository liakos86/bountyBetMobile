import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../enums/MatchEventStatusMore.dart';
import 'Score.dart';
import 'Team.dart';
import 'TimeDetails.dart';
import 'constants/MatchConstants.dart';

class MatchEvent{


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

  String status_more;

  Team homeTeam ;

  Score ?homeTeamScore;

  Team awayTeam;

  Score ?awayTeamScore;

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

	void calculateLiveMinute() {
		DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);
		DateTime? currentPeriodStartTime;


		if (timeDetails != null && timeDetails!.currentPeriodStartTimestamp > 0){
			currentPeriodStartTime = DateTime.fromMillisecondsSinceEpoch(timeDetails!.currentPeriodStartTimestamp * 1000).toLocal();
		}

		DateTime matchTime = matchTimeFormat.parseUtc(start_at).toLocal();
		start_at_local = '${matchTime.hour < 10 ? '0' : Constants.empty}${matchTime.hour}:${matchTime.minute < 10 ? '0' : Constants.empty}${matchTime.minute}' ;

		currentPeriodStartTime ??= matchTime;

		MatchEventStatus? eventStatus = MatchEventStatus.fromStatusText(status);
		if (! (MatchEventStatus.INPROGRESS == eventStatus)) {

			if (MatchEventStatus.FINISHED == eventStatus){
				//print(homeTeam.name +  ' stsus more iss:' + status_more);
				display_status = MatchEventStatusMore.fromStatusMoreText(status_more)!.statusStr;
				return;
				// if (lastedPeriod == null){
				// 	display_status = 'FT';
				// 	return;
				// }
				//
				// LastedPeriod? lastedPeriodEnum = LastedPeriod.fromStatusText(lastedPeriod!);
				//
				// if ( LastedPeriod.PERIOD_2 == lastedPeriodEnum) {
				// 	display_status = 'FT';
				// 	return;
				// }
				//
				// if (LastedPeriod.EXTRA_2 == lastedPeriodEnum) {
				// 	display_status = 'After Extra Time';
				// 	return;
				// }
				//
				// if (LastedPeriod.PENALTIES == lastedPeriodEnum) {
				// 	display_status = 'After Penalties';
				// 	return;
				// }
			}

			display_status = start_at_local;
			return;
		}


		MatchEventStatusMore? matchEventStatusMore = MatchEventStatusMore.fromStatusMoreText(status_more);
		if (matchEventStatusMore == null){
			return;
		}

		if (MatchEventStatusMore.INPROGRESS_HALFTIME == matchEventStatusMore ||
				MatchEventStatusMore.INPROGRESS_HALFTIME_EXTRA == matchEventStatusMore) {
			display_status = matchEventStatusMore.statusStr;
			return;
		}

	 if (MatchEventStatusMore.INPROGRESS_HALFTIME == matchEventStatusMore) {
			if (ChangeEvent.SECOND_HALF_START == changeEvent){
				display_status = '46';
				changeEvent = ChangeEvent.NONE;
			}
		}else if (MatchEventStatusMore.INPROGRESS_1ST_HALF == matchEventStatusMore) {

			int x = DateTime.now().millisecondsSinceEpoch - currentPeriodStartTime.millisecondsSinceEpoch;
			int minute = x ~/ 60000;
			if (minute > 45) {
				String injury1st = Constants.empty;
				if (minute - 45 >0){
					injury1st = (minute - 45).toString();
				}

				display_status = "45+$injury1st";
			} else {
				display_status = "$minute'";
			}
		} else if (MatchEventStatusMore.INPROGRESS_2ND_HALF == (matchEventStatusMore)) {
	 		int firstHalfMinutes = 45;

			int millisecondsSinceMatchStart = DateTime
					.now()
					.millisecondsSinceEpoch - currentPeriodStartTime.millisecondsSinceEpoch;
			int minute = firstHalfMinutes + (millisecondsSinceMatchStart ~/ 60000);// - 15; // 15 is for half time break

			if (minute > 90) {
				String injury2nd = (minute - 45).toString();//90).toString();
				display_status = "90+$injury2nd";
			} else {
				display_status = "$minute'";
			}
		} else if (MatchEventStatusMore.INPROGRESS_1ST_EXTRA == (matchEventStatusMore)) {// TODO:  extra time etc
		 int firstMinutes = 90;

		 int millisecondsSinceMatchStart = DateTime
				 .now()
				 .millisecondsSinceEpoch - currentPeriodStartTime.millisecondsSinceEpoch;

		 int minute = firstMinutes + (millisecondsSinceMatchStart ~/ 60000);// - 15; // 15 is for half time break

		 if (minute > 105){// 90) {
			 String injury2nd = (minute - 15).toString();//90).toString();
			 display_status = "105+$injury2nd";
		 } else {
			 display_status = "$minute'";
		 }
		}else if (MatchEventStatusMore.INPROGRESS_2ND_EXTRA == (matchEventStatusMore)) {// TODO:  extra time etc
		 int firstMinutes = 105;

		 int millisecondsSinceMatchStart = DateTime
				 .now()
				 .millisecondsSinceEpoch - currentPeriodStartTime.millisecondsSinceEpoch;

		 int minute = firstMinutes + (millisecondsSinceMatchStart ~/ 60000);// - 15; // 15 is for half time break

		 if (minute > 120){// 90) {
			 String injury2nd = (minute - 15).toString();//90).toString();
			 display_status = "120+$injury2nd";
		 } else {
			 display_status = "$minute'";
		 }
	 }else if (MatchEventStatusMore.INPROGRESS_PENALTIES == (matchEventStatusMore)) {
	 	 display_status = 'Penalty shootout';
	 } else{
		 display_status = status_more;
	 }

	}

	@override
	operator == (other) =>
			other is MatchEvent &&
					other.eventId == eventId ;

	@override
	int get hashCode => eventId * 37;

  void copyFrom(MatchEvent incomingEvent) {
  	changeEvent = incomingEvent.changeEvent;
  	homeTeamScore?.copyFrom(incomingEvent.homeTeamScore);
  	awayTeamScore?.copyFrom(incomingEvent.awayTeamScore);
  	start_at_local = incomingEvent.start_at_local;
  	display_status = incomingEvent.display_status;
		if (eventId==2388941){
			print('aa');
		}
  	status = incomingEvent.status;
  	status_more = incomingEvent.status_more;
  	timeDetails = incomingEvent.timeDetails;

	}

}