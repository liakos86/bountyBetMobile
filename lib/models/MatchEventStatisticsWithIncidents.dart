import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';

import 'MatchEventIncidentSoccer.dart';
import 'MatchEventStatisticSoccer.dart';
import 'Player.dart';
import 'constants/JsonConstants.dart';

class MatchEventStatisticsWithIncidents{

  int eventId=-1;

  MatchEventIncidentsSoccer incidents = MatchEventIncidentsSoccer();

  MatchEventStatisticsSoccer statistics = MatchEventStatisticsSoccer();

  
  static List<MatchEventIncidentSoccer> incidentsFromJson(matchIncidentsWrapperJson) {
    List<MatchEventIncidentSoccer> incidents = <MatchEventIncidentSoccer>[];

    var matchIncidentsJson = matchIncidentsWrapperJson[JsonConstants.data];
    for (var incidentJson in matchIncidentsJson){
      MatchEventIncidentSoccer incident = MatchEventIncidentSoccer(
        id: incidentJson[JsonConstants.id],
        event_id: incidentJson[JsonConstants.eventId],
        incident_type: incidentJson['incident_type'],
        time: incidentJson['time'],
        order: incidentJson['order'],
      );

      incident.text = incidentJson[JsonConstants.text];

      incident.card_type = incidentJson['card_type'];

      incident.scoring_team = incidentJson['scoring_team'];
      incident.reason = incidentJson['reason'];
      incident.player_team = incidentJson['player_team'];
      incident.scoring_team = incidentJson['scoring_team'];
      incident.home_score = incidentJson[JsonConstants.homeScore];
      incident.away_score = incidentJson[JsonConstants.awayScore];

      incident.player = playerFromJson(incidentJson['player']);
      incident.player_two_in = playerFromJson(incidentJson['player_two_in']);

      incidents.add(incident);
    }

    incidents.sort();
    return incidents;
  }


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
      m.eventId = int.parse(responseDec['eventId']);
      m.statistics = MatchEventStatisticsSoccer.fromJson(responseDec['matchEventStatistics']);
      m.incidents = MatchEventIncidentsSoccer.fromJson(responseDec['matchEventIncidents']);
     return m;
  }

}