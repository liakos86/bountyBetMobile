import 'package:flutter_app/models/match_event.dart';

import 'Season.dart';
import 'Section.dart';

class League{

  League({
    required this.name,
    required this.league_id,
    required this.has_logo,
    required this.events
  } );

  League.defLeague();

  Map<String, String> ?translations;

  Section ?section;

  List<Season> seasons = <Season>[];

  bool has_logo = false;

  String name = '';

  int league_id = 0;

  String ?logo ;

  List<MatchEvent> events = <MatchEvent>[];

  List<MatchEvent> getEvents(){
    return events;
  }

}