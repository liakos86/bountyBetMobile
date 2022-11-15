import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/match_odds.dart';

import '../enums/ChangeEvent.dart';
import 'Score.dart';
import 'Team.dart';

class MatchEvent{

  MatchEvent({
    required this.eventId,
    required this.homeTeam,
    required this.awayTeam,
    required this.odds,
    required this.status
  } );

  List<MatchEventsStatisticsSoccer> statistics = <MatchEventsStatisticsSoccer>[];

  Map<String, String> ?translations;

  int eventId;

  String ?status_for_client;

  String status;

  String ?status_more;

  int ?startHour;

  int ?startMinute;

  Team homeTeam ;

  Score ?homeTeamScore;

  Team awayTeam;

  Score ?awayTeamScore;

  MatchOdds odds;

  ChangeEvent ?changeEvent;

}