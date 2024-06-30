
import 'constants/JsonConstants.dart';

class MatchEventStatisticSoccer {

  int id;
  // int event_id;
  String period; //"ALL"
  String group; //"Shots"
  String name; //"Shots"
  String home; //"Shots"
  String away; //"Shots"
  int compare_code; // 1, 2, 3 = X


  MatchEventStatisticSoccer({
    required this.id,
    // required this.event_id,
    required this.period,
    required this.group,
    required this.name,
    required this.home,
    required this.away,
    required this.compare_code,
  }  );

  static fromJson(model) {
    return new MatchEventStatisticSoccer(id: int.parse(model[JsonConstants.id]),  period: model['period'], group: model['group'], name: model[JsonConstants.name], home: model['home'], away: model['away'], compare_code: int.parse(model['compare_code']));
  }


}