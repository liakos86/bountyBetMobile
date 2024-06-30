import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'StatisticsNameType.dart';


enum StatisticsNameType{

  NONE(nameCode: Constants.empty),

  ball_possession(nameCode: "ball_possession"),

  total_shots(nameCode: "total_shots"),

  shots_on_target(nameCode: "shots_on_target"),

  shots_off_target(nameCode: "shots_off_target"),
fouls(nameCode: "fouls"),
free_kicks(nameCode: "free_kicks"),
throw_ins(nameCode: "throw_ins"),
passes(nameCode: "passes"),
accurate_passes(nameCode: "accurate_passes"),
long_balls(nameCode: "long_balls"),
crosses(nameCode: "crosses"),
dribbles(nameCode: "dribbles"),
possession_lost(nameCode: "possession_lost"),
duels_won(nameCode: "duels_won"),
aerials_won(nameCode: "aerials_won"),
clearances(nameCode: "clearances"),
expected_goals(nameCode: "expected_goals"),
goal_kicks(nameCode: "goal_kicks"),
shots_outside_box(nameCode: "shots_outside_box"),
shots_inside_box(nameCode: "shots_inside_box"),
goals_prevented(nameCode: "goals_prevented"),
tackles(nameCode: "tackles"),
interceptions(nameCode: "interceptions"),
corner_kicks(nameCode: "corner_kicks"),
offsides(nameCode: "offsides"),
yellow_cards(nameCode: "yellow_cards"),
red_cards(nameCode: "red_cards"),
goalkeeper_saves(nameCode: "goalkeeper_saves"),
counter_attacks(nameCode: "counter_attacks"),
counter_attack_shots(nameCode: "counter_attack_shots"),
blocked_shots(nameCode: "blocked_shots"),
hit_woodwork(nameCode: "hit_woodwork"),
big_chances_missed(nameCode: "big_chances_missed");

  final String nameCode;

  const StatisticsNameType({
    required this.nameCode
  })  ;

  static StatisticsNameType ofStatus(String code){
    for (StatisticsNameType status in StatisticsNameType.values){
      if (code == status.nameCode){
        return status;
      }
    }

    // print('****** STAT NAME:' + code);

    return StatisticsNameType.NONE;
  }

  static getLocalizedString(context, String type){
    switch (type) {
      case 'corner_kicks':
        return AppLocalizations.of(context)!.corner_kicks;
      case 'expected_goals':
        return AppLocalizations.of(context)!.expected_goals;
      case 'yellow_cards':
        return AppLocalizations.of(context)!.yellow_cards;
      case 'red_cards':
        return AppLocalizations.of(context)!.red_cards;
      case 'total_shots':
        return AppLocalizations.of(context)!.total_shots;
      case 'shots_on_target':
        return AppLocalizations.of(context)!.shots_on_target;
      case 'offsides':
        return AppLocalizations.of(context)!.offsides;
      case 'ball_possession':
        return AppLocalizations.of(context)!.ball_possession;
      default:
        return 'missing $type';
    }

  }

  }

