import 'package:flutter_app/models/match_event.dart';


import 'League.dart';
import 'constants/Constants.dart';

class LeagueWithData implements Comparable<LeagueWithData>{

  LeagueWithData({
    required this.league,
    required this.events,
    required this.dateKey
  } );

  LeagueWithData.defLeague();

  League league = League.defConst();

  List<MatchEvent> events = <MatchEvent>[];

  String dateKey = Constants.empty;

  @override
  operator == (other) =>
      other is LeagueWithData &&
          ((other.league.league_id == league.league_id) && league.league_id > 0 && dateKey == other.dateKey);

  @override
  int get hashCode => league.league_id * 37 * dateKey.hashCode;

  @override
  int compareTo(LeagueWithData other) {
    return league.compareTo(other.league);
  }


}