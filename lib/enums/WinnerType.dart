enum WinnerType{

  NONE(statusCode: 1),

  NORMAL(statusCode: 2),

  AFTER(statusCode: 3);

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

print('****** WINNER CODE:' + code.toString());

    return WinnerType.NONE;
  }

}