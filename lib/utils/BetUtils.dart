 import 'package:flutter_app/enums/MatchEventStatusMore.dart';

import '../enums/MatchEventStatus.dart';
import '../enums/WinnerType.dart';
import '../models/UserPrediction.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/match_event.dart';

class BetUtils{

  static double finalOddOf(List<UserPrediction> preds){
      double oddValue = 0;
      for (UserPrediction odd in preds){
        double oddCurrent = odd.value;
        if (oddValue == 0){
          oddValue = oddCurrent;
          continue;
        }
        oddValue = oddValue * oddCurrent;
      }

      return oddValue;
  }

  static getLocalizedMonthString(context, month, year) {
    // DateTime dt = DateTime.now();
    // int currentMonth = dt.month;
    switch (month) {
      case 1:
        return '${AppLocalizations.of(context)!.january} $year';
      case 2:
        return '${AppLocalizations.of(context)!.february} $year';
      case 3:
        return '${AppLocalizations.of(context)!.march} $year';
      case 4:
        return '${AppLocalizations.of(context)!.april} $year';
      case 5:
        return '${AppLocalizations.of(context)!.may} $year';
      case 6:
        return '${AppLocalizations.of(context)!.june} $year';
      case 7:
        return '${AppLocalizations.of(context)!.july} $year';
      case 8:
        return '${AppLocalizations.of(context)!.august} $year';
      case 9:
        return '${AppLocalizations.of(context)!.september} $year';
      case 10:
        return '${AppLocalizations.of(context)!.october} $year';
      case 11:
        return '${AppLocalizations.of(context)!.november} $year';
      case 12:
        return '${AppLocalizations.of(context)!.december} ${year}';
      default:
        return 'This month';
    }
  }

  static WinnerType calculateWinnerType(MatchEvent gameWithOdds) {

    if (MatchEventStatus.FINISHED != MatchEventStatus.fromStatusText(gameWithOdds.status)
        && MatchEventStatusMore.ENDED != MatchEventStatusMore.fromStatusMoreText(gameWithOdds.status_more)) {
      return WinnerType.NONE;
    }

    if (gameWithOdds.aggregated_winner_code != null){
      if (gameWithOdds.aggregated_winner_code == 1){
        return WinnerType.AGGREGATED_HOME;
      }else if (gameWithOdds.aggregated_winner_code == 2){
        return WinnerType.AGGREGATED_AWAY;
      }

      return WinnerType.NONE;
    }

    if (gameWithOdds.winnerCodeNormalTime != null){

      if (gameWithOdds.winnerCodeNormalTime == 1){
        return WinnerType.NORMAL_HOME;
      }

      if (gameWithOdds.winnerCodeNormalTime == 2){
        return WinnerType.NORMAL_AWAY;
      }

      return WinnerType.NONE;
    }

    return WinnerType.NONE;

  }


}