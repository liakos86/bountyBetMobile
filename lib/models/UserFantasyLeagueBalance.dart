import 'constants/Constants.dart';

class UserFantasyLeagueBalance implements Comparable<UserFantasyLeagueBalance>{

  UserFantasyLeagueBalance.defBalance();

  UserFantasyLeagueBalance(this.mongoId);

  String mongoId = Constants.defMongoId;
  double balance = -1;
  double balanceLeaderBoard = -1;

  int position = 0;
  int finalPosition = 0;
  int positionDelta = 0;
  int totalUsers = 0;

  int overallWonBets = 0;
  int overallWonPredictions = 0;
  int overallLostBets = 0;
  int overallLostPredictions = 0;

  double betAmountOverall = 0;
  double betAmountOverallReturned = 0;


  static UserFantasyLeagueBalance fromJson(Map<String, dynamic> parsedJson){


    UserFantasyLeagueBalance user = UserFantasyLeagueBalance(parsedJson['mongoId'].toString());

    if (parsedJson['balanceForLeaderBoard'] != null){
      user.balanceLeaderBoard = parsedJson['balanceForLeaderBoard'] as double;
    }

    if (parsedJson['balance'] != null){
      user.balance = parsedJson['balance'] as double;
    }

    user.position = parsedJson['position']??0 as int ;
    user.finalPosition = parsedJson['finalPosition']??0 as int ;
    user.positionDelta = parsedJson['positionDelta']??0 as int ;
    user.totalUsers = parsedJson['totalUsers']??0 as int ;

    user.betAmountOverall = parsedJson['overallBetAmount']??0;
    user.betAmountOverallReturned = parsedJson['overallBetAmountReturned']??0;

    user.overallWonBets = parsedJson['overallWonSlipsCount'];
    user.overallWonPredictions = parsedJson['overallWonEventsCount'];
    user.overallLostBets = parsedJson['overallLostSlipsCount'];
    user.overallLostPredictions = parsedJson['overallLostEventsCount'];

    return user;

  }

  String percentageROIText(){
    if (betAmountOverall == 0){
      return '0%';
    }

    return '${(( (betAmountOverallReturned - betAmountOverall) / (betAmountOverall)) * 100).toStringAsFixed(0)}%';
  }

  String amountROIText(){
    return '${betAmountOverall.toStringAsFixed(0)}/${betAmountOverallReturned.toStringAsFixed(0)}' ;
  }


  void copyFrom(UserFantasyLeagueBalance u) {
    betAmountOverall = u.betAmountOverall;
    betAmountOverallReturned = u.betAmountOverallReturned;
    finalPosition = u.finalPosition;
    position = u.position;
    positionDelta = u.positionDelta;
    totalUsers = u.totalUsers;
    balance = u.balance;
    balanceLeaderBoard = u.balanceLeaderBoard;
    overallWonBets = u.overallWonBets;
    overallWonPredictions = u.overallWonPredictions;
    overallLostBets = u.overallLostBets;
    overallLostPredictions = u.overallLostPredictions;
  }



  @override
  operator == (other) =>
      other is UserFantasyLeagueBalance &&
          other.mongoId == mongoId ;

  @override
  int get hashCode => mongoId.hashCode ;

  @override
  int compareTo(UserFantasyLeagueBalance other) {

    if (position > other.position){
      return 1;
    }

    if (position < other.position){
      return -1;
    }

    if (balance < other.balance){
      return 1;
    }

    if (balance > other.balance){
      return -1;
    }



    return 0;
  }

}

