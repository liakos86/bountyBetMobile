
 enum MatchEventStatusMore {

  INPROGRESS_1ST_HALF(statusStr: "1st half"),

  INPROGRESS_2ND_HALF(statusStr:"2nd half"),

  INPROGRESS_HALFTIME(statusStr:"Halftime"),

  INPROGRESS_HALFTIME_EXTRA(statusStr:"Halftime extra"),//TODO find this

  INPROGRESS_1ST_EXTRA(statusStr:"1st extra"),

  INPROGRESS_2ND_EXTRA(statusStr:"2nd extra"),

  INPROGRESS_PENALTIES(statusStr:"Penalty shootout"),// TODO find this

  GAME_FINISHED(statusStr:"FT"),

  FINAL_RESULT_ONLY(statusStr:"FRO"),

  NOT_STARTED(statusStr: "Not started"),

  STARTED(statusStr:"Started"),

  ENDED(statusStr:"Ended"),

  RETIRED(statusStr: "Retired"),

  INTERRUPTED(statusStr: "Interrupted"),
  POSTPONED(statusStr: "Postponed"),

  AFTER_EXTRA_TIME(statusStr: "AET"),

  AFTER_PENALTIES(statusStr: "AP"),

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
