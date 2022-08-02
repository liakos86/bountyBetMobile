import 'package:flutter_app/models/match_event.dart';

class League{

  League({
    required this.country_name,
    required this.league_name,
    required this.league_id,
    required this.country_id,
    required this.events
  } );

  String country_id ;

  String country_name ;

  String league_id;

  String league_name ;

  List<MatchEvent> events ;

  List<MatchEvent> getEvents(){
    return events;
  }

}