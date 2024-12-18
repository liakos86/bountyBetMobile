class Score{

  // This is the sum score for normal + extra + penalties of the current match
  int current =0;

  // This is to be displayed
  int ?display;

  // This is first half
  int ?period_1;

  // This is the second half
  int ?period_2;

  // This is 90 minutes
  int ?normal_time;

  // Total goals in extra time
  int? overTime;

  // Penalties score
  int? penalties;

  // Extra first half
  int? extra_1;

  // Extra second half
  int? extra_2;

  Score.def();

  Score(
     this.current,
     this.display,
     this.normal_time,
     this.period_1,
     this.period_2
  );

  void copyFrom(Score incoming){
    this.current = incoming.current;
    this.display = incoming?.display;
    this.normal_time = incoming?.normal_time;
    this.period_1 = incoming?.period_1;
    this.period_2 = incoming?.period_2;
  }

     static Score fromJson(Map<String, dynamic> jsonValues){
       int current = int.parse(jsonValues['current']);
       int display = int.parse(jsonValues['display']);
       int normal_time = int.parse(jsonValues['normal_time']);
       int period_1 = int.parse(jsonValues['period_1']);
       int period_2 = int.parse(jsonValues['period_2']);
      return Score(current, display, normal_time, period_1, period_2);
    }


}