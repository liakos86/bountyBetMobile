import 'package:flutter_app/models/constants/Constants.dart';

enum StatisticsGroupType{

  NONE(groupCode: Constants.empty),

  POSSESSION(groupCode: "possession"),

  SHOTS(groupCode: "shots"),

  TV_DATA(groupCode: "tvdata"),

  PASSES(groupCode: "passes"),

  DUELS(groupCode: "duels"),

  DEFENDING(groupCode: "defending"),

  EXPECTED(groupCode: "expected"),

  SHOTS_EXTRA(groupCode: "shots_extra");

  final String groupCode;

  const StatisticsGroupType({
    required this.groupCode
  })  ;

  static StatisticsGroupType ofStatus(String code){
    for (StatisticsGroupType status in StatisticsGroupType.values){
      if (code == status.groupCode){
        return status;
      }
    }

    print('****** GROUP CODE:' + code);

    return StatisticsGroupType.NONE;
  }

}