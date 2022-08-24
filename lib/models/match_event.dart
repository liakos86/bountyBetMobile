import 'package:flutter_app/models/match_odds.dart';

class MatchEvent{

  MatchEvent({
    required this.eventId,
    required this.homeTeam,
    required this.awayTeam,
    required this.odds
  } );

  String eventId;

  String ?eventDate;

  String ?eventTime;

  String homeTeam ;

  String awayTeam;

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