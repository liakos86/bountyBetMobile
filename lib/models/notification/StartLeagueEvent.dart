
class StartLeagueEvent{

  StartLeagueEvent({
    required this.leagueId,
    required this.leagueName,
    required this.dtStart,
    required this.dtEnd,
    required this.imgUrl,
    required this.uniqueId,
  } );

  String leagueId;

  String leagueName;

  String dtStart;

  String dtEnd;

  String imgUrl;

  String uniqueId;

  //invite only
  String? mongoReceiverId;
  String? invitingUsername;
  String? invitingEmail;


  static StartLeagueEvent fromJson(Map<String, dynamic> jsonValues){
    String leagueId = (jsonValues['leagueId']);
    String leagueName = (jsonValues['leagueName']);
    String dtStart = (jsonValues['dtStart']);
    String dtEnd = (jsonValues['dtEnd']);
    String uniqueId = (jsonValues['uniqueId']);
    String imgUrl = (jsonValues['imgUrl']);
    String? mongoReceiverId = (jsonValues['mongoReceiverId']);
    String? invitingUsername = (jsonValues['invitingUsername']);
    String? invitingEmail = (jsonValues['invitingEmail']);
    StartLeagueEvent sle = StartLeagueEvent(leagueId: leagueId, uniqueId: uniqueId, imgUrl: imgUrl, leagueName: leagueName, dtStart: dtStart, dtEnd: dtEnd);
    sle.mongoReceiverId = mongoReceiverId;
    sle.invitingUsername = invitingUsername;
    sle.invitingEmail = invitingEmail;
    return sle;
  }

}