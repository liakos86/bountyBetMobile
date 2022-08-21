enum BetStatus{

  PENDING(statusCode: 1),

  WON(statusCode: 2),

  LOST(statusCode: 3);

  final int statusCode;

  const BetStatus({
    required this.statusCode
  })  ;

  static BetStatus ofStatus(int code){
    for (BetStatus status in BetStatus.values){
      if (code == status.statusCode){
        return status;
      }
    }

    return BetStatus.PENDING;
  }

}