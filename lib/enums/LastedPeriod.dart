
 enum LastedPeriod {

  PERIOD_2(period: "period_2"),

  EXTRA_2(period:"extra_2"),

  PENALTIES(period:"penalties");

  final String period;

  const LastedPeriod ({
  required this.period});

 static LastedPeriod? fromStatusText(String str) {
  for (LastedPeriod status in LastedPeriod.values) {
    if (status.period == str) {
    return status;
    }
  }

    //print('****** LAsTED PERIOD:' + str);

  return null;
}

}
