import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

// import 'Season.dart';
import 'Section.dart';
import 'League.dart';

class LeagueWithData implements Comparable<LeagueWithData>{

  LeagueWithData({
    required this.league,
    // required this.name,
    // required this.league_id,
    // required this.has_logo,
    required this.events,
    // required this.priority
  } );

  LeagueWithData.defLeague();

  League league = League.defConst();

  // Map<String, String> ?translations;

  // Section section = Section('Other');

  // List<Season> seasons = <Season>[];

  // bool has_logo = false;

  // String name = Constants.empty;

  // int league_id = 0;

  // String? logo ;//= Constants.assetNoLeagueImage;

  List<MatchEvent> events = <MatchEvent>[];

  List<MatchEvent> liveEvents = <MatchEvent>[];

  // int priority = -1;

  @override
  operator == (other) =>
      other is LeagueWithData &&
          other.league.league_id == league.league_id ;

  @override
  int get hashCode => league.league_id * 37;

  @override
  int compareTo(LeagueWithData other) {
    if (this.league.priority > other.league.priority){
      return -1;
    }

    if (this.league.priority < other.league.priority){
      return 1;
    }

    return 0;
  }


}