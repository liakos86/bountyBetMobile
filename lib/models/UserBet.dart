import 'dart:convert';

import '../enums/BetStatus.dart';
import 'UserPrediction.dart';

class UserBet{

  String userMongoId;

  List<UserPrediction> predictions;

  double betAmount;

  BetStatus betStatus = BetStatus.PENDING;

  UserBet({
    required this.userMongoId,
    required this.predictions,
    required this.betAmount
  } );

  double toReturn(){
    double toReturn = betAmount;
    for (UserPrediction odd in predictions){
      toReturn = toReturn * odd.value;
    }

    return toReturn;
  }

  /*
   * No need to send a status, server will always set it to PENDING.
   */
  Map<String, dynamic> toJson() {
    return {
      "mongoUserId": this.userMongoId,
      "betAmount": this.betAmount.toString(),
      "predictions" : this.predictions.map((i) => i.toJson()).toList()//jsonEncode(this.predictions)
    };
  }

  static UserBet fromJson(Map<String, dynamic> parsedJson){
    return UserBet(userMongoId: parsedJson['mongoUserId'].toString(),
        betAmount: parsedJson['betAmount'] as double,
        predictions:  (parsedJson['predictions'] as List)
            .map((prediction) =>  UserPrediction.fromJson(prediction))
            .toList());
  }


}