
import 'Player.dart';

class MatchEventIncidentsSoccer implements Comparable{

  int id;
  int event_id ;
  String incident_type; //"Card"
  int time ;
  // Object time_over ;
  int order ;
  String? text;
  int? scoring_team ;
  int? player_team ;
  int? home_score ;
  int? away_score ;
  String? card_type ; // "Yellow"
  bool? is_missed ;
  String? reason ; //"foul"
  int? length ;
  Player? player ;
  Player? player_two_in ;

  MatchEventIncidentsSoccer({
    required this.id,
    required this.event_id,
    required this.incident_type,
    required this.time,
    required this.order,
  }  );

  @override
  int compareTo(other) {
    if (!(other is MatchEventIncidentsSoccer)){
      return 0;
    }

    MatchEventIncidentsSoccer otherStat = other;
    return this.order - otherStat.order;
  }




}