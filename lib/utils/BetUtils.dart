 import '../models/UserPrediction.dart';

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

}