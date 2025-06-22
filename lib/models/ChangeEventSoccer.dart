
import '../enums/ChangeEvent.dart';

class ChangeEventSoccer{

  ChangeEventSoccer({
    required this.eventId,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.changeEvent,
    required this.homeTeam,
    required this.awayTeam,
    required this.imgUrl,
    required this.uniqueId,
  } );

  int eventId;

  int homeTeamScore;

  int awayTeamScore;

  String homeTeam;

  String awayTeam;

  ChangeEvent changeEvent;

  String imgUrl;

  String uniqueId;

  static ChangeEventSoccer fromJson(Map<String, dynamic> jsonValues){
    int eventId = int.parse(jsonValues['eventId']);
    int homeScore = int.parse(jsonValues['homeScore']);
    int awayScore = int.parse(jsonValues['awayScore']);
    String homeTeam = (jsonValues['homeTeam']);
    String awayTeam = (jsonValues['awayTeam']);
    String imgUrl = (jsonValues['imgUrl']);
    String uniqueId = (jsonValues['uniqueId']);
    ChangeEvent changeEvent = ChangeEvent.ofCode(int.parse(jsonValues['changeEvent']));
    return ChangeEventSoccer(eventId: eventId, uniqueId: uniqueId, imgUrl: imgUrl, homeTeamScore: homeScore, awayTeamScore: awayScore, changeEvent: changeEvent, homeTeam: homeTeam, awayTeam: awayTeam);
  }

}