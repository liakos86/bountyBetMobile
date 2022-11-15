import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/Section.dart';
import 'package:flutter_app/models/Team.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';

import '../models/Player.dart';
import '../models/Score.dart';
import '../models/UserPrediction.dart';
import '../models/league.dart';


class MockUtils {

  final String LOGO_BASE_URL ="https://tipsscore.com/resb/team/";

  final List<Team> mockTeams = <Team>[];

  MockUtils(){

  }

  List<League> mockLeagues(bool live){
    mockTeams.clear();
    mockTeams.add(newTeam('panathinaikos'));
    mockTeams.add(newTeam('liverpool'));
    mockTeams.add(newTeam('benfica'));
    mockTeams.add(newTeam('olympiacos'));
    mockTeams.add(newTeam('arsenal'));
    mockTeams.add(newTeam('paok'));
    mockTeams.add(newTeam('asteras-tripolis'));
    mockTeams.add(newTeam('sevilla'));
    mockTeams.add(newTeam('barcelona'));
    mockTeams.add(newTeam('paniliakos'));
    List<League> leagues = <League>[];

    var events = <MatchEvent>[];
    Set<MatchEvent> eventsMock = mockEvents();
    for (MatchEvent event in eventsMock){
     if (live && event.status == MatchConstants.IN_PROGRESS) {
        events.add(event);
      }else if (!live){
        events.add(event);
      }
    }

    League league = League(events: events,  has_logo: true, name: "Mock country", league_id: 2);
    league.logo = "https://tipsscore.com/resb/league/europe-uefa-champions-league.png" ;

    Section section = Section("Section name");
    league.section = section;

    leagues.add(league);

    return leagues;
  }

  Set<MatchEvent> mockEvents() {
    Set<MatchEvent> mockEvents = LinkedHashSet();
    MatchEvent mockEvent1 = mockEvent(1, 1.5, 3.4, 5.0, 1.95, 1.85, MatchConstants.IN_PROGRESS, "60", ChangeEvent.NONE);
    mockEvents.add(mockEvent1);
    MatchEvent mockEvent2 = mockEvent(2, 1.58, 4.4, 5.76, 1.95, 1.85, MatchConstants.NOT_STARTED, "", ChangeEvent.NONE);
    mockEvents.add(mockEvent2);
    MatchEvent mockEvent3 = mockEvent(3, 1.75, 3.1, 6.5, 1.95, 1.85, MatchConstants.IN_PROGRESS, "65", ChangeEvent.NONE);
    mockEvents.add(mockEvent3);
    MatchEvent mockEvent4 = mockEvent(4, 1.75, 3.1, 6.5, 1.95, 1.85, MatchConstants.NOT_STARTED, "", ChangeEvent.NONE);
    mockEvents.add(mockEvent4);
    MatchEvent mockEvent5 = mockEvent(5, 1.75, 3.1, 6.5, 1.95, 1.85, MatchConstants.IN_PROGRESS, "80", ChangeEvent.NONE);
    mockEvents.add(mockEvent5);

    return mockEvents;
  }

  MatchEvent mockEvent(eventId, odd1, oddx, odd2, oddO25, oddU25, _status, _status_more, _changeEvent){
    MatchOdds mockOdds1 = mockOdds(eventId, odd1, oddx, odd2, oddO25, oddU25);

    MatchEvent event = MatchEvent(eventId: eventId, homeTeam: pickTeam() , awayTeam : pickTeam(), odds: mockOdds1, status: _status);

    event.changeEvent = _changeEvent;
    event.status_more = _status_more;
    event.status_for_client = _status_more+"'";
    event.startHour = 20;
    event.startMinute = 0;
    event.homeTeamScore = Score(1, 1, eventId, eventId, eventId);
    event.awayTeamScore = Score(1, 1, eventId, eventId, eventId);

    int random = Random().nextInt(5);
    if (random == 1){
      event.homeTeamScore!.current = (event.homeTeamScore!.current)! + 1;
      event.changeEvent = ChangeEvent.HOME_GOAL;
    }else{
      event.changeEvent = ChangeEvent.NONE;
    }

    event.statistics = mockStats();

    return event;
  }

  MatchOdds mockOdds(eventId, _odd1, _oddx, _odd2, _oddO25, _oddU25){
    return MatchOdds(
        odd1: UserPrediction(betPredictionType: BetPredictionType.HOME_WIN, eventId: eventId, value: _odd1),
        oddX: UserPrediction(betPredictionType:BetPredictionType.DRAW, eventId: eventId,value: _oddx),
        odd2: UserPrediction(betPredictionType:BetPredictionType.AWAY_WIN, eventId: eventId,value: _odd2),
        oddO25: UserPrediction(betPredictionType:BetPredictionType.OVER_25, eventId: eventId,value: _oddO25),
        oddU25: UserPrediction(betPredictionType:BetPredictionType.UNDER_25, eventId: eventId,value: _oddU25));
  }

  User mockUser(List<League> validData) {
    var events = validData.first.getEvents();
    // League firstLeague = validData.first;
    List<UserBet> userBets = <UserBet>[];


    for (int j=3;j>0;j--) {

      List<UserPrediction> predictions = <UserPrediction>[];
      UserBet bet = UserBet(userMongoId: "62ff5c5988a49a2e2a3ed9aa",
          predictions: predictions,
          betAmount: 5);
      for (int i = 1; i < 4; i++) {
        UserPrediction prediction = UserPrediction(
            betPredictionType: BetPredictionType.of(1, i), eventId: events.first.eventId
            , value: (2.1 + i));
        prediction.betPredictionStatus = BetPredictionStatus.ofStatus(i);
        predictions.add(prediction);
      }
      bet.betStatus = BetStatus.ofStatus(j);
      userBets.add(bet);
    }
    return new User("mockUser", 1200, userBets);
  }

  Team newTeam(String teamName) {
    return Team(Random().nextInt(10000000), teamName, LOGO_BASE_URL + teamName + ".png");
  }

  pickTeam() {
    return mockTeams.removeLast();
  }

  List<MatchEventsStatisticsSoccer> mockStats() {
    List<MatchEventsStatisticsSoccer> stats = <MatchEventsStatisticsSoccer>[];
    stats.add(mockStat(23, "card", 1));
    stats.add(mockStat(23, "goal", 2));
    stats.add(mockStat(23, "substitution", 2));
    stats.add(mockStat(23, "card", 1));
    stats.add(mockStat(23, "card", 2));
    return stats;
  }

  MatchEventsStatisticsSoccer mockStat(int time, String incident, int team) {
    MatchEventsStatisticsSoccer stat = MatchEventsStatisticsSoccer(id: 1, event_id: 1, incident_type: incident, time: time, order: 1);
    stat.player_team = team;
    stat.player = Player(has_photo: true, photo: "https://tipsscore.com/resb/player/sebastien-mladen.png",
    name: 'mockovic', id: 1, position: 'f', position_name: 'forward', sport_id: 1, name_short: 'mockovic');
    return stat;

  }

}