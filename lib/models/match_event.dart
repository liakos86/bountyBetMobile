import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/MatchStatsConstants.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';

import '../enums/ChangeEvent.dart';
import '../enums/MatchEventStatus.dart';
import '../enums/MatchEventStatusMore.dart';
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

  List<MatchEventsStatisticsSoccer> statistics = <MatchEventsStatisticsSoccer>[];

  Map<String, String> ?translations;

  int eventId;

  String display_status = Constants.empty;

	String start_at;

  String status;

  String status_more;

  // int ?startHour;
	//
  // int ?startMinute;

  Team homeTeam ;

  Score ?homeTeamScore;

  Team awayTeam;

  Score ?awayTeamScore;

  MatchOdds? odds;

  ChangeEvent ?changeEvent;

	void calculateLiveMinute() {

		DateFormat matchTimeFormat = DateFormat(MatchConstants.MATCH_START_TIME_FORMAT);
		DateTime matchTime = matchTimeFormat.parseUtc(start_at).toLocal();

		if (! (MatchEventStatus.INPROGRESS == (MatchEventStatus.fromStatusText(status)))) {

			display_status = '${matchTime.hour < 10 ? '0' : ''}${matchTime.hour}:${matchTime.minute < 10 ? '0' : ''}${matchTime.minute}' ;

			return;
		}


		MatchEventStatusMore? matchEventStatusMore = MatchEventStatusMore.fromStatusMoreText(status_more);
		if (MatchEventStatusMore.INPROGRESS_HALFTIME == (matchEventStatusMore)) {
			display_status = MatchEventStatusMore.INPROGRESS_HALFTIME.statusStr;
			return;
		}




		 if (MatchEventStatusMore.INPROGRESS_HALFTIME == status_more) {

			if (ChangeEvent.SECOND_HALF_START == changeEvent){
				display_status = '46';
				changeEvent = ChangeEvent.NONE;
			}

		}else if (MatchEventStatusMore.INPROGRESS_1ST_HALF == (matchEventStatusMore)) {
			int x = DateTime
					.now()
					.millisecondsSinceEpoch - matchTime.millisecondsSinceEpoch;
			int minute = (x / 60000).toInt();
			if (minute > 45) {
				this.display_status = "45+";
			} else {
				this.display_status = (minute).toString();
			}
		} else if (MatchEventStatusMore.INPROGRESS_2ND_HALF == (matchEventStatusMore)) {
			int x = DateTime
					.now()
					.millisecondsSinceEpoch - matchTime.millisecondsSinceEpoch;
			int minute = (x / 60000).toInt();
			if (minute > 90) {
				this.display_status = "90+";
			} else {
				this.display_status = (minute).toString();
			}
		} else {// TODO:  extra time etc
			this.display_status = "ELSE!";
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
  	homeTeamScore = incomingEvent.homeTeamScore;
  	awayTeamScore = incomingEvent.awayTeamScore;
	}

}