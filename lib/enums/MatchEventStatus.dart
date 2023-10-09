
 enum MatchEventStatus {

  INPROGRESS(statusStr: "inprogress"),

  CANCELLED(statusStr:"cancelled"),

  NOTSTARTED(statusStr:"notstarted"),

  POSTPONED(statusStr:"postponed"),

  FINISHED(statusStr:"finished"),

  DELAYED(statusStr:"delayed"),

  INTERRUPTED(statusStr:"interrupted"),

  SUSPENDED(statusStr:"suspended"),

  WILL_CONTINUE (statusStr:"willcontinue");

  final String statusStr;

  const MatchEventStatus ({
  required this.statusStr});

 static MatchEventStatus? fromStatusText(String str) {
  for (MatchEventStatus status in MatchEventStatus.values) {
    if (status.statusStr == str) {
    return status;
    }
  }

  return null;
}

}
