
import 'constants/JsonConstants.dart';

class MatchEventStatisticSoccer{

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
    return new MatchEventStatisticSoccer(id: model[JsonConstants.id],  period: model['period'], group: model['group'], name: model[JsonConstants.name], home: model['home'], away: model['away'], compare_code: model['compare_code']);
  }

  @override
  operator == (other) =>
      other is MatchEventStatisticSoccer &&
          other.id == id ;

  @override
  int get hashCode => id * 37;

  void copyFrom(MatchEventStatisticSoccer meis) {
    home = meis.home;
    away = meis.away;
    compare_code = meis.compare_code;
  }



}