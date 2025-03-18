import 'dart:convert';

import 'package:flutter_app/models/UserBet.dart';

import '../enums/UserLevel.dart';
import 'UserAward.dart';
import 'constants/Constants.dart';

class User implements Comparable<User>{

  User.defUser();

  User(this.mongoUserId, this.username, this.userBets);

  String mongoUserId = Constants.defMongoId;

  bool validated = false;

  String username = Constants.empty;

  String email = Constants.empty;

  String errorMessage = Constants.empty;

  double balance = -1;
  double balanceLeaderBoard = -1;

  List<UserAward> awards = <UserAward>[];

  UserLevel userLevel = UserLevel.bettingVisitor;

  int monthlyWonBets = 0;
  int monthlyWonPredictions = 0;
  int monthlyLostBets = 0;
  int monthlyLostPredictions = 0;

  int overallWonBets = 0;
  int overallWonPredictions = 0;
  int overallLostBets = 0;
  int overallLostPredictions = 0;

  int userPosition = 0;

  double betAmountOverall = 0;
  double betAmountMonthly = 0;

  List<UserBet> userBets = <UserBet>[];

  static User fromJson(Map<String, dynamic> parsedJson){
    if (parsedJson['errorMessage'] != null) {
      User user  = User.defUser();
      user.errorMessage = parsedJson['errorMessage'];
      return user;
    }

    List<UserBet> bets = <UserBet>[];

    if (parsedJson['userBets'] != null){
      bets.addAll( (parsedJson['userBets'] as List)
          .map((data) =>  UserBet.fromJson(data))
          .toList()
      );
    }

    User user = User(parsedJson['mongoId'].toString(), parsedJson['username'].toString(), bets);

    if (parsedJson['balanceLeaderBoard'] != null){
      user.balanceLeaderBoard = parsedJson['balanceLeaderBoard'] as double;
    }

    if (parsedJson['balance'] != null){
      user.balance = parsedJson['balance'] as double;
    }

    user.validated = parsedJson['validated'] as bool;
    user.email = parsedJson['email'];


    user.betAmountOverall = parsedJson['overallBetAmount']??0;
    user.betAmountMonthly = parsedJson['monthlyBetAmount']??0;

    user.monthlyWonBets = parsedJson['monthlyWonSlipsCount']??0;
    user.monthlyWonPredictions = parsedJson['monthlyWonEventsCount']??0;
    user.monthlyLostBets = parsedJson['monthlyLostSlipsCount']??0;
    user.monthlyLostPredictions = parsedJson['monthlyLostEventsCount']??0;

    user.overallWonBets = parsedJson['overallWonSlipsCount'];
    user.overallWonPredictions = parsedJson['overallWonEventsCount'];
    user.overallLostBets = parsedJson['overallLostSlipsCount'];
    user.overallLostPredictions = parsedJson['overallLostEventsCount'];

    user.userLevel = UserLevel.ofLevelCode(parsedJson['level']);
    user.userPosition = parsedJson['position']??0 as int ;

    if (parsedJson['userAwards'] != null){
      user.awards.clear();
        for (dynamic award in parsedJson['userAwards']){
          user.awards.add(UserAward.fromJson(award));
        }
    }

    return user;

  }

  String betSlipsMonthlyText(){
    return '$monthlyWonBets/${monthlyWonBets + monthlyLostBets}';
  }

  String betSlipsMonthlyPercentageText(){
    if (monthlyWonBets + monthlyLostBets == 0){
      return '0%';
    }

    return '${(monthlyWonBets / (monthlyWonBets + monthlyLostBets) * 100).toStringAsFixed(0)}%';
  }

  double betSlipsOverallPercentage(){
    if (overallWonBets + overallLostBets == 0){
      return 0;
    }

    return overallWonBets / (overallWonBets + overallLostBets) ;
  }

  double betPredsOverallPercentage(){
    if (overallWonPredictions + overallLostPredictions == 0){
      return 0;
    }

    return overallWonPredictions / (overallWonPredictions + overallLostPredictions) ;
  }

  String monthlyROIPercentageText(){
    if (betAmountMonthly == 0){
      return '0%';
    }

    return '${(( (balance - 1000) / (betAmountMonthly)) * 100).toStringAsFixed(0)}%';
  }

  String betSlipsOverallText(){
    return '$overallWonBets/${overallWonBets + overallLostBets}';
  }

  String betPredictionsMonthlyText(){
    return '$monthlyWonPredictions/${monthlyWonPredictions + monthlyLostPredictions}';
  }

  String betPredictionsMonthlyPercentageText(){
    if (monthlyWonPredictions + monthlyLostPredictions == 0){
      return '0%';
    }

    return '${((monthlyWonPredictions/(monthlyWonPredictions + monthlyLostPredictions)) * 100).toStringAsFixed(0)}%';
  }

  String betPredictionsOverallText(){
    return '$overallWonPredictions/${overallWonPredictions + overallLostPredictions}';
  }

  void copyBalancesFrom(User u) {
    userPosition = u.userPosition;
    betAmountMonthly = u.betAmountMonthly;
    betAmountOverall = u.betAmountOverall;
    balance = u.balance;
    balanceLeaderBoard = u.balanceLeaderBoard;
    monthlyLostBets = u.monthlyLostBets;
    monthlyLostPredictions = u.monthlyLostPredictions;
    monthlyWonBets = u.monthlyWonBets;
    monthlyWonPredictions = u.monthlyWonPredictions;
    overallLostBets = u.overallLostBets;
    overallLostPredictions = u.overallLostPredictions;
    overallWonPredictions = u.overallWonPredictions;
    overallWonBets = u.overallWonBets;
  }

  @override
  operator == (other) =>
      other is User &&
          other.mongoUserId == mongoUserId ;

  @override
  int get hashCode => mongoUserId.hashCode ;

  @override
  int compareTo(User other) {
    if (this.userPosition > other.userPosition){
      return 1;
    }

    if (this.userPosition < other.userPosition){
      return -1;
    }

    return 0;
  }

}

