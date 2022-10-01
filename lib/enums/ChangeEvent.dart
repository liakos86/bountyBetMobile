enum ChangeEvent{

  NONE(changeCode: "0"),

  HOME_GOAL(changeCode: "1"),

  AWAY_GOAL(changeCode: "2"),

  RED_CARD(changeCode: "3");

  final String changeCode;

  const ChangeEvent({
    required this.changeCode
  });

  static ChangeEvent ofCode(String ?code){

    if (code?.isEmpty ?? true){
      return ChangeEvent.NONE;
    }

    for (ChangeEvent status in ChangeEvent.values){
      if (code == status.changeCode){
        return status;
      }
    }

    return ChangeEvent.NONE;
  }

}