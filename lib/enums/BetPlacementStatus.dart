enum BetPlacementStatus{

  PLACED(statusCode: 1, statusText:'\"placed\"'),

  FAILED_MATCH_IN_PROGRESS(statusCode:2, statusText:'\"FAILED_MATCH_IN_PROGRESS\"'),

  FAIL_GENERIC(statusCode:3, statusText:'failed'),

  FAILED_INSUFFICIENT_FUNDS(statusCode:4, statusText: '\"failedInsufficient\"'),

  FAILED_USER_NOT_VALIDATED(statusCode:5, statusText: '\"failedNotValidated\"'),

  PENDING(statusCode:6, statusText: '\"pending\"');

  final int statusCode;

  final String statusText;

  const BetPlacementStatus({
    required this.statusCode,
    required this.statusText
  })  ;

  static BetPlacementStatus ofStatus(int code){
    for (BetPlacementStatus status in BetPlacementStatus.values){
      if (code == status.statusCode){
        return status;
      }
    }
    return BetPlacementStatus.FAIL_GENERIC;
  }

static BetPlacementStatus ofStatusText(String text){
for (BetPlacementStatus status in BetPlacementStatus.values){
if (text.trim().toLowerCase() == status.statusText.trim().toLowerCase()){
return status;
}
}
return BetPlacementStatus.FAIL_GENERIC;
}

}