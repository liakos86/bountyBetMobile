
import 'package:flutter_app/models/UserBet.dart';

import '../enums/UserLevel.dart';
import 'FantasyLeague.dart';
// import 'UserAward.dart';
import 'UserMonthlyBalance.dart';
import 'constants/Constants.dart';

class User implements Comparable<User>{

  User.defUser();

  User(this.mongoUserId, this.username, this.userBets);

  String mongoUserId = Constants.defMongoId;

  bool validated = false;

  String username = Constants.empty;

  String email = Constants.empty;

  String errorMessage = Constants.empty;

  UserMonthlyBalance balance = UserMonthlyBalance.defBalance();

  List<UserMonthlyBalance> awards = <UserMonthlyBalance>[];
  List<FantasyLeague> fantasyLeagues = <FantasyLeague>[];

  UserLevel userLevel = UserLevel.bettingVisitor;

  int overallWonBets = 0;
  int overallWonPredictions = 0;
  int overallLostBets = 0;
  int overallLostPredictions = 0;

  double betAmountOverall = 0;


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

    user.validated = parsedJson['validated'] as bool;
    user.email = parsedJson['email'];


    user.betAmountOverall = parsedJson['overallBetAmount']??0;

    user.overallWonBets = parsedJson['overallWonSlipsCount'];
    user.overallWonPredictions = parsedJson['overallWonEventsCount'];
    user.overallLostBets = parsedJson['overallLostSlipsCount'];
    user.overallLostPredictions = parsedJson['overallLostEventsCount'];

    user.userLevel = UserLevel.ofLevelCode(parsedJson['level']);

    if(parsedJson['balanceObject'] != null) {
      user.balance = UserMonthlyBalance.fromJson(parsedJson['balanceObject']);
    }

    if (parsedJson['userAwards'] != null){
      user.awards.clear();
        for (dynamic award in parsedJson['userAwards']){
          user.awards.add(UserMonthlyBalance.fromJson(award));
        }
    }

    return user;

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


  String betSlipsOverallText(){
    return '$overallWonBets/${overallWonBets + overallLostBets}';
  }


  String betPredictionsOverallText(){
    return '$overallWonPredictions/${overallWonPredictions + overallLostPredictions}';
  }

  void deepCopyFrom(User u) {
    // userPosition = u.userPosition;
    email = u.email;
    validated = u.validated;
    username = u.username;
    mongoUserId = u.mongoUserId;
    betAmountOverall = u.betAmountOverall;
    overallLostBets = u.overallLostBets;
    overallLostPredictions = u.overallLostPredictions;
    overallWonPredictions = u.overallWonPredictions;
    overallWonBets = u.overallWonBets;
    balance.copyBalancesFrom(u.balance);
    // userBets = u.userBets;
    copyBets(u.userBets);
    copyAwards(u.awards);
  }

  @override
  operator == (other) =>
      other is User &&
          other.mongoUserId == mongoUserId ;

  @override
  int get hashCode => mongoUserId.hashCode ;

  @override
  int compareTo(User other) {
    if (this.balance.balanceLeaderBoard > other.balance.balanceLeaderBoard){//if (this.userPosition > other.userPosition){
      return -1;
    }

    if (this.balance.balanceLeaderBoard < other.balance.balanceLeaderBoard){
      return 1;
    }

    return 0;
  }

  void copyBets(List<UserBet> incomingBets) {
    for (UserBet bet in List.of(userBets)){
      UserBet incoming = incomingBets.firstWhere((element) => element.betId == bet.betId, orElse: () => UserBet.defBet());
      if (incoming.betId == Constants.defMongoId){
        userBets.remove(bet);
      }else{
        bet.copyFrom(incoming);
      }
    }

    for (UserBet incoming in incomingBets){
      UserBet existing = userBets.firstWhere((element) => element.betId == incoming.betId, orElse: () => UserBet.defBet());
      if (existing.betId == Constants.defMongoId){
        userBets.add(incoming);
      }
    }

  }

  void copyAwards(List<UserMonthlyBalance> incomingAwards) {
    for (UserMonthlyBalance award in List.of(awards)){
      UserMonthlyBalance incoming = incomingAwards.firstWhere((element) => element.mongoId == award.mongoId , orElse: () => UserMonthlyBalance.defBalance());
      if (incoming.mongoId == Constants.defMongoId){
        awards.remove(award);
      }else{
        award.copyBalancesFrom(incoming);
      }
    }

    for (UserMonthlyBalance incoming in incomingAwards){
      UserMonthlyBalance existing = awards.firstWhere((element) => element.mongoId == incoming.mongoId , orElse: () => UserMonthlyBalance.defBalance());
      if (existing.mongoId == Constants.defMongoId){
        awards.add(incoming);
      }
    }
  }

}

