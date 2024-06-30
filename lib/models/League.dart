import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

// import 'Season.dart';
import 'Section.dart';
import 'constants/JsonConstants.dart';

class League {

  League({
    required this.name,
    required this.league_id,
    required this.has_logo,
    required this.priority
  });

  League.defConst();

  Map<String, String> ?translations;

  Section section = Section('Other');//TODO remove?

  bool has_logo = false;

  String name = Constants.empty;

  int league_id = 0;

  String? logo;

  List<int> seasonIds = <int>[];
  //
  // List<MatchEvent> liveEvents = <MatchEvent>[];

  int priority = -1;

  static League fromJson(league) {
    League li = League(
        name: league[JsonConstants.name],
        league_id: league[JsonConstants.id],
        has_logo: league[JsonConstants.hasLogo],
        priority: league[JsonConstants.priority]
    );

    var sectionJson = league[JsonConstants.section];
    if (sectionJson != null) {
      Section section = Section(sectionJson[JsonConstants.name]);
      li.section = section;
    }

    li.logo = league[JsonConstants.logo];

    List<int> leagueSeasonIds = <int>[];
    var seasonsJson = league['seasonIds'];
    if (seasonsJson != null ){
      for (int seasonJson in seasonsJson) {
        leagueSeasonIds.add(seasonJson);
      }
    }

    li.seasonIds = leagueSeasonIds;

    return li;
  }
}

