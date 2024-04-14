class Score{

  int ?current;

  int ?display;

  int ?period_1;

  int ?period_2;

  int ?normal_time;

  Score(
     this.current,
     this.display,
     this.normal_time,
     this.period_1,
     this.period_2
  );

  void copyFrom(Score? incoming){
    this.current = incoming?.current;
    this.display = incoming?.display;
    this.normal_time = incoming?.normal_time;
    this.period_1 = incoming?.period_1;
    this.period_2 = incoming?.period_2;
  }

     static Score fromJson(Map<String, dynamic> jsonValues){
       int current = jsonValues['current'];
       int display = jsonValues['display'];
       int normal_time = jsonValues['normal_time'];
       int period_1 = jsonValues['period_1'];
       int period_2 = jsonValues['period_2'];
      return Score(current, display, normal_time, period_1, period_2);
    }


}