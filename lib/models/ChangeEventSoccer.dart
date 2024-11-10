
import '../enums/ChangeEvent.dart';

class ChangeEventSoccer{

  ChangeEventSoccer({
    required this.eventId,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.changeEvent,
  } );

  int eventId;

  int homeTeamScore;

  int awayTeamScore;

  ChangeEvent changeEvent;

  static ChangeEventSoccer fromJson(Map<String, dynamic> jsonValues){
    int eventId = int.parse(jsonValues['eventId']);
    int homeScore = int.parse(jsonValues['homeScore']);
    int awayScore = int.parse(jsonValues['awayScore']);
    ChangeEvent changeEvent = ChangeEvent.ofCode(int.parse(jsonValues['changeEvent']));
    return ChangeEventSoccer(eventId: eventId, homeTeamScore: homeScore, awayTeamScore: awayScore, changeEvent: changeEvent);
  }

}