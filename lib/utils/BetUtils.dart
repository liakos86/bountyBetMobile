 import '../models/UserPrediction.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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


}