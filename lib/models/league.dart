import 'package:flutter_app/models/match_event.dart';

class League{

  League({
    required this.name,
    required this.league_id,
    required this.has_logo,
    required this.events
  } );

  bool has_logo ;

  String name ;

  int league_id;

  String ?logo ;

  List<MatchEvent> events ;

  List<MatchEvent> getEvents(){
    return events;
  }

}