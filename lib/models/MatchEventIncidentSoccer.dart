
import 'package:flutter_app/models/constants/JsonConstants.dart';

import 'Player.dart';

class MatchEventIncidentSoccer implements Comparable{

  int id;
  int event_id ;
  String incident_type; //"Card"
  int time ; //minute
  int order ;

  int? time_over ; // value for injury time
  String? text; // e.g. regular or penalty or ownGoal for goal, HT or FT
  int? scoring_team ; //null for injury time
  int? player_team ; // 1 or 2 or null
  int? home_score ;
  int? away_score ;
  String? card_type ; // "Yellow"
  Object? is_missed ; // for penalty? ?
  String? reason ; //"foul" , "time_wasting", "Argument", "woodwork"
  int? length ; // ????
  Player? player ;
  Player? player_two_in ;// substituted player, or assist player

  MatchEventIncidentSoccer({
    required this.id,
    required this.event_id,
    required this.incident_type,
    required this.time,
    required this.order,
  }  );

  @override
  int compareTo(other) {
    if (other is! MatchEventIncidentSoccer){
      return 0;
    }

    if (order > other.order){
      return 1;
    }

    return -1;
  }

  static fromJson(model) {
    MatchEventIncidentSoccer incident = new MatchEventIncidentSoccer(
        id: int.parse(model[JsonConstants.id]),
        event_id: int.parse(model[JsonConstants.eventId]), incident_type: model['incident_type'],
        time: int.parse(model['time']), order: int.parse(model['order']));

    if (model['time_over']  != null) {
      incident.time_over = int.parse( model['time_over'] ) ; // value for injury time
    }


    incident.text = model[JsonConstants.text]; // e.g. regular or penalty or ownGoal for goal, HT or FT

    if (model['scoring_team']  != null) {
      incident.scoring_team = int.parse(model['scoring_team']); //null for injury time
    }

    if (model['player_team']  != null) {
      incident.player_team = int.parse(model['player_team']); // 1 or 2 or null
    }

    if (model[JsonConstants.homeScore]  != null) {
      incident.home_score = int.parse(model[JsonConstants.homeScore]);
    }

    if (model[JsonConstants.awayScore]  != null) {
      incident.away_score = int.parse(model[JsonConstants.awayScore]);
    }

    incident.card_type = model['card_type']; // "Yellow"
    incident.is_missed = model['is_missed']; // for penalty? ?
    incident.reason = model['reason']; //"foul" , "time_wasting", "Argument", "woodwork"

    if (model['length']  != null) {
      incident.length = int.parse(model['length']); // ????
    }

    incident.player = Player.fromJson(model['player']);
    incident.player_two_in = Player.fromJson(model['player_two_in']);


   return incident;
  }




}