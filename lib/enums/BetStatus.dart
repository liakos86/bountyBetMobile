enum BetStatus{

  PENDING(statusCode: 1),

  WON(statusCode: 2),

  LOST(statusCode: 3);

  final int statusCode;

  const BetStatus({
    required this.statusCode
  })  ;

}