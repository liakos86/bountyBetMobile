
import 'package:flutter_app/models/UserBet.dart';

import '../enums/UserLevel.dart';
import 'FantasyLeague.dart';
// import 'UserAward.dart';
import 'UserFantasyLeagueBalance.dart';
import 'UserMonthlyBalance.dart';
import 'UserPurchase.dart';
import 'constants/Constants.dart';

class User implements Comparable<User>{

  User.defUser();

  User(this.mongoUserId, this.username, this.userBets);

  String mongoUserId = Constants.defMongoId;

  String? fantasyLeagueMongoId;

  bool validated = false;

  bool passwordReset = false;

  String username = Constants.empty;

  String email = Constants.empty;

  int globalPosition = 0;
  int positionDelta = 0;
  int totalUsers = 0;

  String errorMessage = Constants.empty;

  UserFantasyLeagueBalance fantasyBalance = UserFantasyLeagueBalance.defBalance();

  List<UserMonthlyBalance> awards = <UserMonthlyBalance>[];

  List<UserPurchase> purchases = <UserPurchase>[];

  UserLevel userLevel = UserLevel.bettingVisitor;

  int overallWonBets = 0;
  int overallWonPredictions = 0;
  int overallLostBets = 0;
  int overallLostPredictions = 0;

  double betAmountOverall = 0;
  double betAmountOverallReturned = 0;


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

    List<UserPurchase> purchases = <UserPurchase>[];
    if (parsedJson['purchases'] != null){
      purchases.addAll( (parsedJson['purchases'] as List)
          .map((data) =>  UserPurchase.fromJson(data))
          .toList()
      );
    }

    user.purchases = purchases;
    user.validated = parsedJson['validated'] as bool;
    user.email = parsedJson['email'];

    if(parsedJson['fantasyLeagueMongoId'] != null) {
      user.fantasyLeagueMongoId = parsedJson['fantasyLeagueMongoId'];
    }

    if(parsedJson['passwordReset'] != null) {
      user.passwordReset = parsedJson['passwordReset'] as bool;
    }


    user.betAmountOverall = parsedJson['overallBetAmount']??0;
    user.betAmountOverallReturned = parsedJson['overallBetAmountReturned']??0;

    user.globalPosition = parsedJson['globalPosition']??0;
    user.positionDelta = parsedJson['positionDelta']??0;
    user.totalUsers = parsedJson['totalUsers']??0;

    user.overallWonBets = parsedJson['overallWonSlipsCount'];
    user.overallWonPredictions = parsedJson['overallWonEventsCount'];
    user.overallLostBets = parsedJson['overallLostSlipsCount'];
    user.overallLostPredictions = parsedJson['overallLostEventsCount'];

    user.userLevel = UserLevel.ofLevelCode(parsedJson['level']);

    if(parsedJson['fantasyLeagueBalanceObject'] != null) {
      user.fantasyBalance = UserFantasyLeagueBalance.fromJson(parsedJson['fantasyLeagueBalanceObject']);
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

  double betPredictionsOverallPercentage(){
    if (overallWonPredictions + overallLostPredictions == 0){
      return 0;
    }

    return overallWonPredictions / (overallWonPredictions + overallLostPredictions) ;
  }

  String betPredictionsOverallPercentageText(){
    return '${(betPredictionsOverallPercentage() * 100) .toStringAsFixed(0)}%';
  }

  String betSlipsOverallText(){
    return '$overallWonBets/${overallWonBets + overallLostBets}';
  }


  String betPredictionsOverallText(){
    return '$overallWonPredictions/${overallWonPredictions + overallLostPredictions}';
  }

  String overallROIPercentageText(){
    if (betAmountOverall == 0){
      return '0%';
    }

    return '${(( (betAmountOverallReturned - betAmountOverall) / (betAmountOverall)) * 100).toStringAsFixed(0)}%';
  }

  String overallROIAmountText(){
    bool roundBalance = betAmountOverall  == betAmountOverall.roundToDouble();
    int digits = roundBalance ? 0 : 1;

    bool roundBalanceRet = betAmountOverallReturned  == betAmountOverallReturned.roundToDouble();
    int digitsRet = roundBalanceRet ? 0 : 1;

   return '${betAmountOverall.toStringAsFixed(digits)}/${betAmountOverallReturned.toStringAsFixed(digitsRet)}';
  }

  String betSlipsPercentageText(){
    if (overallWonBets + overallLostBets == 0){
      return 'bets 0%';
    }

    double slipsPercentage = (overallWonBets * 100) / (overallWonBets + overallLostBets) ;
    bool roundBalance = slipsPercentage  == slipsPercentage.roundToDouble();
    int digits = roundBalance ? 0 : 1;


    return 'bets ${slipsPercentage.toStringAsFixed(digits)}%';

  }

  void deepCopyFrom(User u) {
    // userPosition = u.userPosition;
    email = u.email;
    validated = u.validated;
    passwordReset = u.passwordReset;
    username = u.username;
    mongoUserId = u.mongoUserId;
    betAmountOverall = u.betAmountOverall;
    betAmountOverallReturned = u.betAmountOverallReturned;
    overallLostBets = u.overallLostBets;
    overallLostPredictions = u.overallLostPredictions;
    overallWonPredictions = u.overallWonPredictions;
    overallWonBets = u.overallWonBets;
    globalPosition = u.globalPosition;
    positionDelta = u.positionDelta;
    totalUsers = u.totalUsers;
    // balance.copyBalancesFrom(u.balance);
    fantasyLeagueMongoId = u.fantasyLeagueMongoId;
    // userBets = u.userBets;
    copyBets(u.userBets);
    copyAwards(u.awards);
    copyPurchases(u.purchases);


    if (u.fantasyBalance.mongoId != Constants.defMongoId) {
      fantasyBalance.copyFrom(u.fantasyBalance);
    }

  }

  @override
  operator == (other) =>
      other is User &&
          other.mongoUserId == mongoUserId ;

  @override
  int get hashCode => mongoUserId.hashCode ;

  @override
  int compareTo(User other) {
    if (this.overallWonBets > other.overallWonBets){//if (this.userPosition > other.userPosition){
      return -1;
    }

    if (this.overallWonBets < other.overallWonBets){
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

  void copyPurchases(List<UserPurchase> incomingPurchases) {
    for (UserPurchase purchase in List.of(purchases)){
      UserPurchase incoming = incomingPurchases.firstWhere((element) => element.mongoId == purchase.mongoId , orElse: () => UserPurchase.def());
      if (incoming.mongoId == Constants.defMongoId){
        purchases.remove(purchase);
      }else{
        purchase.copyFrom(incoming);
      }
    }

    for (UserPurchase incoming in incomingPurchases){
      UserPurchase existing = purchases.firstWhere((element) => element.mongoId == incoming.mongoId , orElse: () => UserPurchase.def());
      if (existing.mongoId == Constants.defMongoId){
        purchases.add(incoming);
      }
    }
  }

}

