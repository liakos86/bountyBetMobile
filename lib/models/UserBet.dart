import 'dart:convert';

import '../enums/BetStatus.dart';
import 'UserPrediction.dart';

class UserBet implements Comparable<UserBet>{

  String userMongoId;

  List<UserPrediction> predictions;

  double betAmount;

  int betPlacementMillis;

  BetStatus betStatus = BetStatus.PENDING;

  UserBet({
    required this.userMongoId,
    required this.predictions,
    required this.betAmount,
    required this.betStatus,
    required this.betPlacementMillis
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
        betStatus:  BetStatus.ofStatus(parsedJson['betStatus'] as int),
        betPlacementMillis: parsedJson['betPlacementMillis'],
        predictions:  (parsedJson['predictions'] as List)
            .map((prediction) =>  UserPrediction.fromJson(prediction))
            .toList());
  }

  @override
  int compareTo(UserBet other){
    if (betPlacementMillis > other.betPlacementMillis){
      return -1;
    }

    if (betPlacementMillis < other.betPlacementMillis){
      return 1;
    }

    return 1;
  }


}