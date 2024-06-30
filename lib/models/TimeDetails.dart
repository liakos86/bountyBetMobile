class TimeDetails{

  int injuryTime1 = 0;
  int injuryTime2 = 0;
  int injuryTime3 = 0;
  int injuryTime4 = 0;
  int initial =0;
  int max =0;
  int extra =0;
  int currentPeriodStartTimestamp = 0;

  static TimeDetails? fromJson(timeDetailsMap) {
    if (timeDetailsMap == null){
      return null;
    }

    TimeDetails timeDetails = TimeDetails();

    if (timeDetailsMap['initial'] != null){
      timeDetails.initial = timeDetailsMap['initial'];
    }

    if (timeDetailsMap['max'] != null){
      timeDetails.max = timeDetailsMap['max'];
    }

    if (timeDetailsMap['extra'] != null){
      timeDetails.extra = timeDetailsMap['extra'];
    }

    if (timeDetailsMap['injuryTime1'] != null){
      timeDetails.injuryTime1 = timeDetailsMap['injuryTime1'];
    }

    if (timeDetailsMap['injuryTime2'] != null){
      timeDetails.injuryTime2 = timeDetailsMap['injuryTime2'];
    }

    if (timeDetailsMap['injuryTime3'] != null){
      timeDetails.injuryTime3 = timeDetailsMap['injuryTime3'];
    }

    if (timeDetailsMap['injuryTime4'] != null){
      timeDetails.injuryTime4 = timeDetailsMap['injuryTime4'];
    }

    if (timeDetailsMap['currentPeriodStartTimestamp'] != null){
      timeDetails.currentPeriodStartTimestamp = timeDetailsMap['currentPeriodStartTimestamp'];
    }

    return timeDetails;

  }

}