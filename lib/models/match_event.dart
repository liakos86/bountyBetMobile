import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../enums/MatchEventStatusMore.dart';
import 'MatchEventStatisticsSoccer.dart';
import 'Score.dart';
import 'Team.dart';
import 'constants/MatchConstants.dart';

class MatchEvent{


  MatchEvent({
    required this.eventId,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.status_more,
		required this.start_at
  } );

  List<MatchEventIncidentsSoccer> incidents = <MatchEventIncidentsSoccer>[];

	List<MatchEventStatisticsSoccer> statistics = <MatchEventStatisticsSoccer>[];

  Map<String, String> ?translations;

  int eventId;

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

  bool isFavourite = false;

	void calculateLiveMinute() {

		DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);
		DateTime matchTime = matchTimeFormat.parseUtc(start_at).toLocal();
		start_at_local = '${matchTime.hour < 10 ? '0' : Constants.empty}${matchTime.hour}:${matchTime.minute < 10 ? '0' : Constants.empty}${matchTime.minute}' ;

		MatchEventStatus? eventStatus = MatchEventStatus.fromStatusText(status);
		if (! (MatchEventStatus.INPROGRESS == eventStatus)) {

			if (MatchEventStatus.FINISHED == eventStatus){
				display_status = 'FT';
				return;
			}

			display_status = start_at_local;
			return;
		}


		MatchEventStatusMore? matchEventStatusMore = MatchEventStatusMore.fromStatusMoreText(status_more);
		if (MatchEventStatusMore.INPROGRESS_HALFTIME == matchEventStatusMore) {
			display_status = MatchEventStatusMore.INPROGRESS_HALFTIME.statusStr;
			return;
		}

	 if (MatchEventStatusMore.INPROGRESS_HALFTIME == matchEventStatusMore) {
			if (ChangeEvent.SECOND_HALF_START == changeEvent){
				display_status = '46';
				changeEvent = ChangeEvent.NONE;
			}
		}else if (MatchEventStatusMore.INPROGRESS_1ST_HALF == matchEventStatusMore) {
			int x = DateTime
					.now()
					.millisecondsSinceEpoch - matchTime.millisecondsSinceEpoch;
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
			int millisecondsSinceMatchStart = DateTime
					.now()
					.millisecondsSinceEpoch - matchTime.millisecondsSinceEpoch;
			int minute = millisecondsSinceMatchStart ~/ 60000 - 15; // 15 is for half time break
			if (minute > 90) {
				String injury2nd = (minute - 90).toString();
				display_status = "90+$injury2nd";
			} else {
				display_status = "$minute'";
			}
		} else {// TODO:  extra time etc
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
  	status = incomingEvent.status;
  	status_more = incomingEvent.status_more;

  	incidents.clear();
  	statistics.clear();
  	incidents.addAll(incomingEvent.incidents);
  	statistics.addAll(incomingEvent.statistics);

	}

}