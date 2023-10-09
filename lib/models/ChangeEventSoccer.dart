
import 'dart:io';

import '../enums/ChangeEvent.dart';
import 'Score.dart';

class ChangeEventSoccer{

  ChangeEventSoccer({
    required this.eventId,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.changeEvent
  } );

  int eventId;

  Score homeTeamScore;

  Score awayTeamScore;

  ChangeEvent changeEvent;

  static ChangeEventSoccer fromJson(Map<String, dynamic> jsonValues){
    int eventId = jsonValues['eventId'];
    Score homeScore = Score.fromJson(jsonValues['homeScore']);
    Score awayScore = Score.fromJson(jsonValues['awayScore']);
    ChangeEvent changeEvent = ChangeEvent.ofCode(int.parse(jsonValues['changeEvent']));
    return ChangeEventSoccer(eventId: eventId, homeTeamScore: homeScore, awayTeamScore: awayScore, changeEvent: changeEvent);
  }



}