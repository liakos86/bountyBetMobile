import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

// import 'Season.dart';
import 'Section.dart';
import 'League.dart';

class LeagueWithData implements Comparable<LeagueWithData>{

  LeagueWithData({
    required this.league,
    required this.events,
  } );

  LeagueWithData.defLeague();

  League league = League.defConst();

  List<MatchEvent> events = <MatchEvent>[];

  // List<MatchEvent> liveEvents = <MatchEvent>[];

  @override
  operator == (other) =>
      other is LeagueWithData &&
          ((other.league.league_id == league.league_id) && league.league_id > 0);

  @override
  int get hashCode => league.league_id * 37;

  @override
  int compareTo(LeagueWithData other) {
    return league.compareTo(other.league);
  }


}