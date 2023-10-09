enum ChangeEvent{

  NONE(changeCode: 0),

  HOME_GOAL(changeCode: 1),

  AWAY_GOAL(changeCode: 2),

  MATCH_START(changeCode: 3),

  RED_CARD(changeCode: 4),

  HALF_TIME(changeCode: 5),

  FULL_TIME(changeCode: 6),

  SECOND_HALF_START(changeCode: 7);

  final int changeCode;

  const ChangeEvent({
    required this.changeCode
  });

  static bool isGoal(ChangeEvent? e){
    return ChangeEvent.HOME_GOAL == e || ChangeEvent.AWAY_GOAL == e;
  }

  static ChangeEvent ofCode(int code){

    // if (code?.isEmpty ?? true){
    //   return ChangeEvent.NONE;
    // }

    for (ChangeEvent status in ChangeEvent.values){
      if (code == status.changeCode){
        return status;
      }
    }

    return ChangeEvent.NONE;
  }

}