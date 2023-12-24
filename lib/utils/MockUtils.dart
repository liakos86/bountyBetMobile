import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/Section.dart';
import 'package:flutter_app/models/Team.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/MatchIncidentsConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';

import '../enums/MatchEventStatus.dart';
import '../models/Player.dart';
import '../models/Score.dart';
import '../models/UserPrediction.dart';
import '../models/league.dart';


class MockUtils {

  final String LOGO_BASE_URL ="https://tipsscore.com/resb/team/";

  // final List<Team> mockTeams = <Team>[];

  Map<String, List<League>> mockLeaguesMap(Map eventsPerDayMap, bool live){
    Map<String, List<League>> mockLeaguesMap = new LinkedHashMap();
    List<League> leagues = mockLeagues(eventsPerDayMap);
    mockLeaguesMap.putIfAbsent('-1', () => leagues);
    mockLeaguesMap.putIfAbsent('0', () => leagues);
    mockLeaguesMap.putIfAbsent('1', () => leagues);
    return mockLeaguesMap;
  }

  List<League> mockLeagues(Map eventsPerDayMap){
    List<int> existingLeaguesIds = <int>[];
    if (eventsPerDayMap.isNotEmpty) {
      eventsPerDayMap['0']?.forEach((element) {
        existingLeaguesIds.add(element.league_id);
      });
    }else{
      existingLeaguesIds.add(1);
      existingLeaguesIds.add(2);
      existingLeaguesIds.add(3);
    }

    //remove a league and add a new one
    existingLeaguesIds.removeAt(0);
    existingLeaguesIds.insert(0, Random().nextInt(10000));


    //mockTeams.clear();

    List<League> leagues = <League>[];

    existingLeaguesIds.forEach((leagueId) {


      var events = <MatchEvent>[];
      Set<MatchEvent> eventsMock = mockEvents(leagueId);
      events.addAll(eventsMock);
      League league = League(events: events,  has_logo: true, name: "Mock country"+leagueId.toString(), league_id: leagueId, priority: leagueId);

      for (MatchEvent event in eventsMock){
        if (MatchEventStatus.fromStatusText(event.status) == MatchEventStatus.INPROGRESS) {
          league.liveEvents.add(event);
        }
      }

      league.logo = "https://tipsscore.com/resb/league/europe-uefa-champions-league.png" ;

      Section section = Section("Section name"+leagueId.toString());
      league.section = section;

      leagues.add(league);

    });

    return leagues;
  }

  Set<MatchEvent> mockEvents(int leagueId) {
    List<Team> mockTeams = <Team>[];
    mockTeams.add(newTeam('panathinaikos_'+leagueId.toString()));
    mockTeams.add(newTeam('liverpool_'+leagueId.toString()));
    mockTeams.add(newTeam('benfica_'+leagueId.toString()));
    mockTeams.add(newTeam('olympiacos_'+leagueId.toString()));

    Set<MatchEvent> mockEvents = LinkedHashSet();
    MatchEvent mockEvent1 = mockEvent(mockTeams.elementAt(0), mockTeams.elementAt(1), 1, 1.5, 3.4, 5.0, 1.95, 1.85, MatchEventStatus.INPROGRESS.statusStr, "60", ChangeEvent.NONE);
    mockEvents.add(mockEvent1);
    MatchEvent mockEvent2 = mockEvent(mockTeams.elementAt(2), mockTeams.elementAt(3), 2, 1.58, 4.4, 5.76, 1.95, 1.85, MatchEventStatus.NOTSTARTED.statusStr, "", ChangeEvent.NONE);
    mockEvents.add(mockEvent2);
    return mockEvents;
  }

  MatchEvent mockEvent(team1, team2, eventId, odd1, oddx, odd2, oddO25, oddU25, _status, _status_more, _changeEvent){
    MatchOdds mockOdds1 = mockOdds(team1, team2, eventId, odd1, oddx, odd2, oddO25, oddU25);

    MatchEvent event = MatchEvent(eventId: eventId, homeTeam: team1 , awayTeam : team2, status: _status, status_more: _status_more, start_at: '2022-10-13 15:00:00');
    event.odds = mockOdds1;

    event.changeEvent = _changeEvent;
    event.homeTeamScore = Score(1, 1, eventId, eventId, eventId);
    event.awayTeamScore = Score(1, 1, eventId, eventId, eventId);

    int random = Random().nextInt(5);
    if (random == 1){
      event.homeTeamScore!.current = (event.homeTeamScore!.current)! + 1;
      event.changeEvent = ChangeEvent.HOME_GOAL;
    }else{
      event.changeEvent = ChangeEvent.NONE;
    }

    event.incidents = mockStats();

    return event;
  }

  MatchOdds mockOdds(team1, team2, eventId, _odd1, _oddx, _odd2, _oddO25, _oddU25){
    return MatchOdds(
        odd1: UserPrediction(sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType: BetPredictionType.HOME_WIN, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId, value: _odd1),
        oddX: UserPrediction(sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.DRAW, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _oddx),
        odd2: UserPrediction(sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.AWAY_WIN, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _odd2),
        oddO25: UserPrediction(sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.OVER_25, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _oddO25),
        oddU25: UserPrediction(sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.UNDER_25, betPredictionStatus: BetPredictionStatus.PENDING, eventId: eventId,value: _oddU25));
  }

  // User mockUser(Map<String, List<League>> validData) {
  //   var events = validData.entries.first.value.first.events;
  //   // var events = validData.first.getEvents();
  //   // League firstLeague = validData.first;
  //   List<UserBet> userBets = <UserBet>[];
  //
  //
  //   for (int j=3;j>0;j--) {
  //
  //     List<UserPrediction> predictions = <UserPrediction>[];
  //     UserBet bet = UserBet(userMongoId: "62ff5c5988a49a2e2a3ed9aa",
  //         predictions: predictions,
  //         betAmount: 5);
  //     for (int i = 1; i < 4; i++) {
  //       UserPrediction prediction = UserPrediction(homeTeam: team1, awayTeam: team2, sportId: 1,
  //           betPredictionType: BetPredictionType.of(1, i), betPredictionStatus: BetPredictionStatus.PENDING, eventId: events.first.eventId
  //           , value: (2.1 + i));
  //       prediction.betPredictionStatus = BetPredictionStatus.ofStatus(i);
  //       predictions.add(prediction);
  //     }
  //     bet.betStatus = BetStatus.ofStatus(j);
  //     userBets.add(bet);
  //   }
  //   return new User("mongoId", "mockUser", 1200, userBets);
  // }

  Team newTeam(String teamName) {
    return Team(Random().nextInt(10000000), teamName, LOGO_BASE_URL + teamName.split('_')[0] + ".png");
  }

  // pickTeam() {
  //   // try {
  //   //   return mockTeams.removeLast();
  //   // }catch (e){
  //     return Team(Random().nextInt(10000000), "mockTeam", 'https://tipsscore.com/resb/no-league.png');
  //   //}
  // }

  List<MatchEventIncidentsSoccer> mockStats() {
    List<MatchEventIncidentsSoccer> stats = <MatchEventIncidentsSoccer>[];
    stats.add(mockStat(1, 1, "card", 1, null));
    stats.add(mockStat(4, 4, "goal", 2, null));
    stats.add(mockStat(6, 6, "substitution", 2, null));
    stats.add(mockStat(2, 2, "card", 1, null));
    stats.add(mockStat(5, 5, "card", 2, null));

    stats.add(mockStat(3, 45, MatchIncidentsConstants.PERIOD, null, "HT 0 - 0"));


    stats.sort();
    return stats;
  }

  MatchEventIncidentsSoccer mockStat(int order, int time, String incident, int? team, String? text) {
    MatchEventIncidentsSoccer stat = MatchEventIncidentsSoccer(id: 1, event_id: 1, incident_type: incident, time: time, order: order);
    stat.player_team = team;
    stat.player = Player(has_photo: true, photo: "https://tipsscore.com/resb/player/sebastien-mladen.png",
    name: 'mockovic', id: 1, position: 'f', position_name: 'forward', sport_id: 1, name_short: 'mockovic');

    stat.player_two_in = Player(has_photo: true, photo: "https://tipsscore.com/resb/player/neymar.png",
        name: 'mockovic out ', id: 1, position: 'f', position_name: 'forward', sport_id: 1, name_short: 'mockovic out');

    stat.text = text;
    return stat;

  }

}