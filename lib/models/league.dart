import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

import 'Season.dart';
import 'Section.dart';

class League implements Comparable<League>{

  League({
    required this.name,
    required this.league_id,
    required this.has_logo,
    required this.events,
    required this.priority
  } );

  League.defLeague();

  Map<String, String> ?translations;

  Section section = Section('Other');

  List<Season> seasons = <Season>[];

  bool has_logo = false;

  String name = Constants.empty;

  int league_id = 0;

  String? logo ;//= Constants.assetNoLeagueImage;

  List<MatchEvent> events = <MatchEvent>[];

  List<MatchEvent> liveEvents = <MatchEvent>[];

  int priority = -1;

  @override
  operator == (other) =>
      other is League &&
          other.league_id == league_id ;

  @override
  int get hashCode => league_id * 37;

  @override
  int compareTo(League other) {
    if (this.priority > other.priority){
      return -1;
    }

    if (this.priority < other.priority){
      return 1;
    }

    return 0;
  }


}