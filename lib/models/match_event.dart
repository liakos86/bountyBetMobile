import 'package:flutter_app/models/match_odds.dart';

import 'Team.dart';

class MatchEvent{

  MatchEvent({
    required this.eventId,
    required this.homeTeam,
    required this.awayTeam,
    required this.odds
  } );

  int eventId;

  String ?eventDate;

  String ?eventTime;

  Team homeTeam ;

  Team awayTeam;

  MatchOdds odds;
  //
  //
  // String getHomeTeam(){
  //   return homeTeam;
  // }
  //
  // String getAwayTeam(){
  //   return awayTeam;
  // }
  //
  // MatchOdds getMatchOdds(){
  //   return odds;
  // }

}