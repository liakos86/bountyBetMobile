enum ChangeEvent{

  NONE(changeCode: 0, displayName: 'No event'),

  HOME_GOAL(changeCode: 1, displayName: 'GOAL!!!'),

  AWAY_GOAL(changeCode: 2, displayName: 'GOAL!!!'),

  MATCH_START(changeCode: 3, displayName: 'Match started.'),

  HOME_RED_CARD(changeCode: 4, displayName: 'Red Card!!!'),

  AWAY_RED_CARD(changeCode: 5, displayName: 'Red Card!!!'),

  HALF_TIME(changeCode: 6, displayName: 'Half time.'),

  FULL_TIME(changeCode: 7, displayName: 'Match ended.'),

  SECOND_HALF_START(changeCode: 8, displayName: 'Second half started.');

  final int changeCode;

  final String displayName;

  const ChangeEvent({
    required this.changeCode,
    required this.displayName
  });

  static bool isGoal(ChangeEvent? e){
    return ChangeEvent.HOME_GOAL == e || ChangeEvent.AWAY_GOAL == e;
  }



  static bool isForNotification(ChangeEvent? e){
    return ChangeEvent.HOME_RED_CARD == e || ChangeEvent.AWAY_RED_CARD == e || isGoal(e) || ChangeEvent.HALF_TIME == e || ChangeEvent.FULL_TIME == e;
  }

  static ChangeEvent ofCode(int code){

    for (ChangeEvent status in ChangeEvent.values){
      if (code == status.changeCode){
        return status;
      }
    }

    return ChangeEvent.NONE;
  }

}