import 'dart:convert';

import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';

import '../enums/UserLevel.dart';
import 'constants/Constants.dart';

class User{

  User.defUser();

  User(this.mongoUserId, this.username, this.balance, this.userBets);

  String mongoUserId = Constants.defMongoUserId;

  bool validated = false;

  String username = Constants.empty;

  String email = Constants.empty;

  String errorMessage = Constants.empty;

  double balance = -1;

  UserLevel userLevel = UserLevel.bettingVisitor;

  int monthlyWonBets = 0;
  int monthlyWonPredictions = 0;
  int monthlyLostBets = 0;
  int monthlyLostPredictions = 0;

  int overallWonBets = 0;
  int overallWonPredictions = 0;
  int overallLostBets = 0;
  int overallLostPredictions = 0;


  List<UserBet> userBets = <UserBet>[];

  static User fromJson(Map<String, dynamic> parsedJson){
    if (parsedJson['errorMessage'] != null) {
      User user  = User.defUser();
      user.errorMessage = parsedJson['errorMessage'];
      return user;
    }


    User user = User(parsedJson['mongoId'].toString(), parsedJson['username'].toString(), parsedJson['balance'] as double,
        (parsedJson['userBets'] as List)
            .map((data) =>  UserBet.fromJson(data))
            .toList()
           );

    user.validated = parsedJson['validated'] as bool;
    user.email = parsedJson['email'];
    user.monthlyWonBets = parsedJson['monthlyWonSlipsCount'];
    user.monthlyWonPredictions = parsedJson['monthlyWonEventsCount'];
    user.monthlyLostBets = parsedJson['monthlyLostSlipsCount'];
    user.monthlyLostPredictions = parsedJson['monthlyLostEventsCount'];

    user.overallWonBets = parsedJson['overallWonSlipsCount'];
    user.overallWonPredictions = parsedJson['overallWonEventsCount'];
    user.overallLostBets = parsedJson['overallLostSlipsCount'];
    user.overallLostPredictions = parsedJson['overallLostEventsCount'];

    user.userLevel = UserLevel.ofLevelCode(parsedJson['level']);

    return user;

  }

  String betSlipsMonthlyText(){
    return '$monthlyWonBets/${monthlyWonBets + monthlyLostBets}';
  }

  String betSlipsOverallText(){
    return '$overallWonBets/${overallWonBets + overallLostBets}';
  }

  String betPredictionsMonthlyText(){
    return '$monthlyWonPredictions/${monthlyWonPredictions + monthlyLostPredictions}';
  }

  String betPredictionsOverallText(){
    return '$overallWonPredictions/${overallWonPredictions + overallLostPredictions}';
  }

}