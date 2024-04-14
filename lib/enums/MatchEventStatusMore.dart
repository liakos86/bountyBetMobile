
 enum MatchEventStatusMore {

  INPROGRESS_1ST_HALF(statusStr: "1st half"),

  INPROGRESS_2ND_HALF(statusStr:"2nd half"),

  INPROGRESS_HALFTIME(statusStr:"Halftime"),

  INPROGRESS_1ST_EXTRA(statusStr:"1st extra"),

  INPROGRESS_2ND_EXTRA(statusStr:"2nd extra"),

  GAME_FINISHED(statusStr:"FT"),

  FINAL_RESULT_ONLY(statusStr:"FRO"),

  STARTED(statusStr:"Started"),

  EMPTY(statusStr:"-")

 ;

 final String statusStr;

 const MatchEventStatusMore( {
  required this.statusStr
 });

 static MatchEventStatusMore? fromStatusMoreText(String str) {
  for (MatchEventStatusMore status in MatchEventStatusMore.values) {
  if (status.statusStr == (str)) {
  return status;
  }
  }

  return null;
 }

}
