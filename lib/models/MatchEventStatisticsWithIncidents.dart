import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';

import 'MatchEventStatisticSoccer.dart';
import 'Player.dart';
import 'constants/JsonConstants.dart';

class MatchEventStatisticsWithIncidents{

  int eventId=-1;

  MatchEventIncidentsSoccer incidents = MatchEventIncidentsSoccer();

  MatchEventStatisticsSoccer statistics = MatchEventStatisticsSoccer();

  static Player? playerFromJson(playerJson) {
    if (playerJson == null){
      return null;
    }

    Player player = Player(id: playerJson[JsonConstants.id],
        sport_id: playerJson['sport_id'],
        name: playerJson[JsonConstants.name],
        name_short: playerJson['name_short'],
        position: playerJson['position'],
        has_photo: playerJson['has_photo'],
        photo: playerJson['photo'],
        position_name: playerJson['position_name']);
    return player;
  }

  static List<MatchEventStatisticSoccer> statsFromJson(matchStatsWrapperJson, int eventId) {
    List<MatchEventStatisticSoccer> stats = <MatchEventStatisticSoccer>[];

    var matchStatsJson = matchStatsWrapperJson[JsonConstants.data];
    for (var statJson in matchStatsJson){
      MatchEventStatisticSoccer stat = MatchEventStatisticSoccer(
          id: statJson[JsonConstants.id],
          // event_id: eventId,
          name: statJson[JsonConstants.name],
          group: statJson['group'],
          period: statJson['period'],
          home: statJson['home'],
          away: statJson['away'],
          compare_code: statJson['compare_code']
      );

      stats.add(stat);
    }

    return stats;
  }

  static MatchEventStatisticsWithIncidents fromJson(responseDec) {
      MatchEventStatisticsWithIncidents m = MatchEventStatisticsWithIncidents();
      m.eventId = (responseDec['eventId']);
      m.statistics = MatchEventStatisticsSoccer.fromJson(responseDec['matchEventStatistics']);
      m.incidents = MatchEventIncidentsSoccer.fromJson(responseDec['matchEventIncidents']);
     return m;
  }

}