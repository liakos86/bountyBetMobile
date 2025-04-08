
import 'package:flutter_app/models/UserBet.dart';

import '../enums/UserLevel.dart';
import 'FantasyLeague.dart';
// import 'UserAward.dart';
import 'constants/Constants.dart';

class UserMonthlyBalance implements Comparable<UserMonthlyBalance>{

  UserMonthlyBalance.defBalance();

  UserMonthlyBalance(this.mongoId);

  String mongoId = Constants.defMongoId;
  double balance = -1;
  double balanceLeaderBoard = -1;
  int month = 0;
  int year = 0;

  int monthlyWonBets = 0;
  int monthlyWonPredictions = 0;
  int monthlyLostBets = 0;
  int monthlyLostPredictions = 0;

  double betAmountMonthly = 0;
  double betAmountMonthlyReturned = 0;

  static UserMonthlyBalance fromJson(Map<String, dynamic> parsedJson){


    UserMonthlyBalance user = UserMonthlyBalance(parsedJson['mongoId'].toString());

    if (parsedJson['balanceForLeaderBoard'] != null){
      user.balanceLeaderBoard = parsedJson['balanceForLeaderBoard'] as double;
    }

    if (parsedJson['balance'] != null){
      user.balance = parsedJson['balance'] as double;
    }

    user.betAmountMonthly = parsedJson['monthlyBetAmount']??0;
    user.betAmountMonthlyReturned = parsedJson['monthlyBetAmountReturned']??0;

    user.monthlyWonBets = parsedJson['monthlyWonSlipsCount']??0;
    user.monthlyWonPredictions = parsedJson['monthlyWonEventsCount']??0;
    user.monthlyLostBets = parsedJson['monthlyLostSlipsCount']??0;
    user.monthlyLostPredictions = parsedJson['monthlyLostEventsCount']??0;

    user.month = parsedJson['month'];
    user.year = parsedJson['year'];

    return user;

  }


  void copyBalancesFrom(UserMonthlyBalance u) {
    betAmountMonthly = u.betAmountMonthly;
    month = u.month;
    year = u.year;
    betAmountMonthlyReturned = u.betAmountMonthlyReturned;
    balance = u.balance;
    balanceLeaderBoard = u.balanceLeaderBoard;
    monthlyLostBets = u.monthlyLostBets;
    monthlyLostPredictions = u.monthlyLostPredictions;
    monthlyWonBets = u.monthlyWonBets;
    monthlyWonPredictions = u.monthlyWonPredictions;
  }


  String betSlipsMonthlyText(){
    if(monthlyWonBets + monthlyLostBets == 0){
      return '0/0';
    }
    return '${monthlyWonBets}/${monthlyWonBets + monthlyLostBets}';
  }

  String betSlipsMonthlyPercentageText(){
    if (monthlyWonBets + monthlyLostBets == 0){
      return '0%';
    }

    return '${(monthlyWonBets / (monthlyWonBets + monthlyLostBets) * 100).toStringAsFixed(0)}%';
  }

  String monthlyROIPercentageText(){
    if (betAmountMonthly == 0){
      return '0%';
    }

    return '${(( (betAmountMonthlyReturned - betAmountMonthly) / (betAmountMonthly)) * 100).toStringAsFixed(0)}%';
  }


  String monthlyAmountROIText(){
    return '${betAmountMonthly.toStringAsFixed(0)}/${betAmountMonthlyReturned.toStringAsFixed(0)}' ;
  }

  String betPredictionsMonthlyText(){
    return monthlyWonPredictions.toString() + '/' + (monthlyWonPredictions + monthlyLostPredictions).toString();
  }

  String betPredictionsMonthlyPercentageText(){
    if (monthlyWonPredictions + monthlyLostPredictions == 0){
      return '0%';
    }

    return '${((monthlyWonPredictions/(monthlyWonPredictions + monthlyLostPredictions)) * 100).toStringAsFixed(0)}%';
  }



  @override
  operator == (other) =>
      other is UserMonthlyBalance &&
          other.mongoId == mongoId ;

  @override
  int get hashCode => mongoId.hashCode ;

  @override
  int compareTo(UserMonthlyBalance other) {
    if (this.month < other.month){//if (this.userPosition > other.userPosition){
      return -1;
    }

    if (this.month > other.month){
      return 1;
    }

    return 0;
  }

}

