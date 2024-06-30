import 'package:flutter_app/models/constants/Constants.dart';

enum StatisticsPeriodType{

  NONE(periodCode: Constants.empty),

  ALL(periodCode: "all"),

  FIRST(periodCode: "1st"),
  SECOND(periodCode: "2nd"),
  EXTRA_FIRST(periodCode: "1et"),
  EXTRA_SECOND(periodCode: "2et");

  final String periodCode;

  const StatisticsPeriodType({
    required this.periodCode
  })  ;

  static StatisticsPeriodType ofStatus(String code){
    for (StatisticsPeriodType status in StatisticsPeriodType.values){
      if (code == status.periodCode){
        return status;
      }
    }

    print('****** PERIOD TYPE:' + code);

    return StatisticsPeriodType.NONE;
  }

}