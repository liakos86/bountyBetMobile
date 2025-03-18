import 'dart:convert';

import 'package:flutter_app/enums/BetPlacementStatus.dart';

import '../enums/BetStatus.dart';
import 'UserPrediction.dart';
import 'constants/Constants.dart';

class UserBet implements Comparable<UserBet>{

  UserBet.defBet();

  String betId = Constants.defMongoId;

  String userMongoId = Constants.defMongoId;

  List<UserPrediction> predictions = <UserPrediction>[];

  double betAmount = -1;

  int betPlacementMillis = -1;

  BetStatus betStatus = BetStatus.PENDING;

  //TODO add from server
  //TODO add from server
  //TODO add from server
  //TODO add from server
  //TODO add from server
  BetPlacementStatus betPlacementStatus = BetPlacementStatus.FAIL_GENERIC;

  UserBet({
    required this.betId,
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
    UserBet bet =  UserBet(userMongoId: parsedJson['mongoUserId'].toString(),
        betId: parsedJson['mongoId'].toString() ,
        betAmount: parsedJson['betAmount'] as double,
        betStatus:  BetStatus.ofStatus(parsedJson['betStatus']),
        betPlacementMillis: parsedJson['betPlacementMillis'],
        predictions:  (parsedJson['predictions'] as List)
            .map((prediction) =>  UserPrediction.fromJson(prediction))
            .toList());

    bet.betPlacementStatus = BetPlacementStatus.ofStatus(parsedJson['betPlacementStatus'] as int);
    return bet;
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

  @override
  operator == (other) =>
      other is UserBet &&
          other.betId == betId ;

  @override
  int get hashCode => betId.hashCode ;

  void copyFrom(UserBet incomingBet) {
    betId = incomingBet.betId;
    betPlacementMillis = incomingBet.betPlacementMillis;
    betStatus = incomingBet.betStatus;

    for(UserPrediction pred in predictions){
      UserPrediction incoming = incomingBet.predictions.firstWhere((element) => element.mongoId == pred.mongoId, orElse: () => UserPrediction.defPrediction());
      pred.copyFrom(incoming);
    }

  }


}