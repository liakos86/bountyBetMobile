enum WinnerType{

  NONE(statusCode: 1),

  NORMAL_HOME(statusCode: 2),

  NORMAL_AWAY(statusCode: 3),

  AGGREGATED_HOME(statusCode: 4),

  AGGREGATED_AWAY(statusCode: 5);

  final int statusCode;

  const WinnerType({
    required this.statusCode
  })  ;

  static WinnerType ofStatus(int code){
    for (WinnerType status in WinnerType.values){
      if (code == status.statusCode){
        return status;
      }
    }

    return WinnerType.NONE;
  }

}