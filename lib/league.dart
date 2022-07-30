import 'package:flutter_app/match_event.dart';

class League{

  String country_id = '';

  String country_name = '';

  String league_id = '';

  String league_name = '';

  List<MatchEvent> events = <MatchEvent>[];

  void setCountryId(countryId){
    this.country_id = countryId;
  }

  void setLeagueId(leagueId){
    this.league_id = leagueId;
  }

  void setCountryName(countryName){
    this.country_name = countryName;
  }

  List<MatchEvent> getEvents(){
    return events;
  }

}