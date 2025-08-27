enum FantasyLeagueStatus{

  PENDING(statusCode: 1),

  RUNNING(statusCode: 2),

  COMPLETED(statusCode: 3),

  ABANDONED(statusCode: 4);

  final int statusCode;

  const FantasyLeagueStatus({
    required this.statusCode
  })  ;

  static FantasyLeagueStatus ofStatus(int code){
    for (FantasyLeagueStatus status in FantasyLeagueStatus.values){
      if (code == status.statusCode){
        return status;
      }
    }

    return FantasyLeagueStatus.PENDING;
  }

}