
class TopupLeagueEvent{

  TopupLeagueEvent({
    required this.leagueId,
    required this.leagueName,
    required this.topUpUser,
    required this.topUpUserId,
    required this.imgUrl,
    required this.uniqueId,
  } );

  String leagueId;

  String leagueName;

  String topUpUser;

  String topUpUserId;

  String imgUrl;

  String uniqueId;


  static TopupLeagueEvent fromJson(Map<String, dynamic> jsonValues){
    String leagueId = (jsonValues['leagueId']);
    String leagueName = (jsonValues['leagueName']);
    String topUpUser = (jsonValues['topUpUser']);
    String topUpUserId = (jsonValues['topUpUserId']);
    String uniqueId = (jsonValues['uniqueId']);
    String imgUrl = (jsonValues['imgUrl']);

    TopupLeagueEvent sle = TopupLeagueEvent(topUpUserId: topUpUserId, leagueId: leagueId, uniqueId: uniqueId, imgUrl: imgUrl, leagueName: leagueName, topUpUser: topUpUser);
    return sle;
  }

}