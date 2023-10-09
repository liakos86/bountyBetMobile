import 'package:flutter/material.dart';

enum UserLevel{

  bettingVisitor(levelCode: 0, levelIcon: 'visibility_sharp'),

  juniorBettingAgent(levelCode: 1, levelIcon: 'star_half'),

  basicBettingAgent(levelCode: 2, levelIcon: 'hourglass_top_outlined'),

  upcomingBettingStar(levelCode: 3, levelIcon: 'star'),

  seniorBettingAgent(levelCode: 4, levelIcon: 'wb_incandescent_sharp'),

  bettingExpert(levelCode: 5, levelIcon: 'lightbulb'),

  bettingMaven(levelCode: 6, levelIcon: 'thunderstorm');

  final int levelCode;

  final String levelIcon;

  const UserLevel({
    required this.levelCode,
    required this.levelIcon
  })  ;

  static UserLevel ofLevelCode(int code){
    for (UserLevel level in UserLevel.values){
      if (code == level.levelCode){
        return level;
      }
    }

    return UserLevel.bettingVisitor;
  }


}

