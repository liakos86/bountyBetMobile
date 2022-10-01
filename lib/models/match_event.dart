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

  int eventId;

  String ?status_for_client;

  String status;

  String ?status_more;

  String ?eventDate;

  String ?eventTime;

  Team homeTeam ;

  Score ?homeTeamScore;

  Team awayTeam;

  Score ?awayTeamScore;

  MatchOdds odds;

  ChangeEvent ?changeEvent;

}