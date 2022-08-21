enum BetPredictionStatus{

  PENDING(statusCode: 1),

  WON(statusCode: 2),

  LOST(statusCode: 3);

  final int statusCode;

  const BetPredictionStatus({
    required this.statusCode
  })  ;

  static BetPredictionStatus ofStatus(int code){
    for (BetPredictionStatus status in BetPredictionStatus.values){
      if (code == status.statusCode){
        return status;
      }
    }
    return BetPredictionStatus.PENDING;
  }

}