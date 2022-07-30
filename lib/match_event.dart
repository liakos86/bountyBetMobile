import 'package:flutter_app/match_odds.dart';

class MatchEvent{

  String homeTeam = '';

  String awayTeam = '';

  MatchOdds odds = MatchOdds();

  void setHomeTeam(homeTeam){
    this.homeTeam = homeTeam;
  }

  void setAwayTeam(awayTeam){
    this.awayTeam = awayTeam;
  }

  void setMatchOdds(odds){
    this.odds = odds;
  }

  String getHomeTeam(){
    return homeTeam;
  }

  String getAwayTeam(){
    return awayTeam;
  }

  MatchOdds getMatchOdds(){
    return odds;
  }

}