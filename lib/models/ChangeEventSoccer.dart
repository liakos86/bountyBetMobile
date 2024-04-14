
import 'dart:io';

import '../enums/ChangeEvent.dart';
import 'Score.dart';
import 'Team.dart';

class ChangeEventSoccer{

  ChangeEventSoccer({
    required this.eventId,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.changeEvent,
    required this.homeTeam,
    required this.awayTeam
  } );

  int eventId;

  Score homeTeamScore;

  Score awayTeamScore;

  Team homeTeam;

  Team awayTeam;

  ChangeEvent changeEvent;

  static ChangeEventSoccer fromJson(Map<String, dynamic> jsonValues){
    int eventId = jsonValues['eventId'];
    Score homeScore = Score.fromJson(jsonValues['homeScore']);
    Score awayScore = Score.fromJson(jsonValues['awayScore']);
    Team homeTeam = Team.fromJson(jsonValues['homeTeam']);
    Team awayTeam = Team.fromJson(jsonValues['awayTeam']);
    ChangeEvent changeEvent = ChangeEvent.ofCode(int.parse(jsonValues['changeEvent']));
    return ChangeEventSoccer(eventId: eventId, homeTeamScore: homeScore, awayTeamScore: awayScore, changeEvent: changeEvent, homeTeam: homeTeam, awayTeam: awayTeam);
  }

}