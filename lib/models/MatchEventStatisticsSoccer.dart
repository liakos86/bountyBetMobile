
import 'Player.dart';

class MatchEventStatisticsSoccer {

  int id;
  String period; //"ALL"
  String group; //"Shots"
  String? name; //"Shots"
  String? home; //"Shots"
  String? away; //"Shots"
  int? compare_code;


  MatchEventStatisticsSoccer({
    required this.id,
    required this.period,
    required this.group,
     this.name,
     this.home,
     this.away,
     this.compare_code,
  }  );


}