
import 'package:flutter_app/models/constants/JsonConstants.dart';

import 'Player.dart';

class MatchEventIncidentSoccer implements Comparable{

  MatchEventIncidentSoccer.defIncident();

  int id = -1;
  int event_id = -1;
  String incident_type = 'none'; //"Card"
  int time = -1; //minute
  int order = -1;

  int? time_over ; // value for injury time
  String? text; // e.g. regular or penalty or ownGoal for goal, HT or FT
  int? scoring_team ; //null for injury time
  int? player_team ; // 1 or 2 or null
  int? home_score ;
  int? away_score ;
  String? card_type ; // "Yellow"
  Object? is_missed ; // for penalty? ?
  String? reason ; //"foul" , "time_wasting", "Argument", "woodwork"
  int? length ; // injury time minutes
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
    print('checking ' + model['incident_type']);
    MatchEventIncidentSoccer incident = new MatchEventIncidentSoccer(
        id: (model[JsonConstants.id]),
        event_id: (model[JsonConstants.eventId]), incident_type: model['incident_type'],
        time: (model['time']), order: (model['order']));

    if (model['time_over']  != null) {
      incident.time_over = ( model['time_over'] ) ; // value for injury time
    }


    incident.text = model[JsonConstants.text]; // e.g. regular or penalty or ownGoal for goal, HT or FT

    if (model['scoring_team']  != null) {
      incident.scoring_team = (model['scoring_team']); //null for injury time
    }

    if (model['player_team']  != null) {
      incident.player_team = (model['player_team']); // 1 or 2 or null
    }

    if (model[JsonConstants.homeScore]  != null) {
      incident.home_score = (model[JsonConstants.homeScore]);
    }

    if (model[JsonConstants.awayScore]  != null) {
      incident.away_score = (model[JsonConstants.awayScore]);
    }

    incident.card_type = model['card_type']; // "Yellow"
    incident.is_missed = model['is_missed']; // for penalty? ?
    incident.reason = model['reason']; //"foul" , "time_wasting", "Argument", "woodwork"

    if (model['length']  != null) {
      incident.length = (model['length']); // ????
    }

    incident.player = Player.fromJson(model['player']);
    incident.player_two_in = Player.fromJson(model['player_two_in']);


   return incident;
  }

  @override
  operator == (other) =>
      other is MatchEventIncidentSoccer &&
          other.id == id ;

  @override
  int get hashCode => id * 37;

  void copyFrom(MatchEventIncidentSoccer meis) {
      length = meis.length;
      id = meis.id;
      event_id = meis.event_id;
       incident_type = meis.incident_type; //"Card"
       time = meis.time; //minute
       order = meis.order;
  }

}