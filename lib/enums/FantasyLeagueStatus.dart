enum FantasyLeagueStatus{

  PENDING(statusCode: 1),

  RUNNING(statusCode: 2),

  ABANDONED(statusCode: 3),

  COMPLETED(statusCode: 4);

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