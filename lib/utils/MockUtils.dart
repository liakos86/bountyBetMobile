import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/enums/LastedPeriod.dart';
import 'package:flutter_app/enums/MatchEventStatusMore.dart';
import 'package:flutter_app/models/Section.dart';
import 'package:flutter_app/models/Team.dart';
import 'package:flutter_app/models/TimeDetails.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/constants/MatchIncidentsConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:intl/intl.dart';

import '../enums/MatchEventStatus.dart';
import '../models/Player.dart';
import '../models/Score.dart';
import '../models/UserMonthlyBalance.dart';
import '../models/UserPrediction.dart';
import '../models/LeagueWithData.dart';
import '../models/League.dart';


class MockUtils {

  final String LOGO_BASE_URL ="https://xscore.cc/resb/team/";

  Map<String, List<LeagueWithData>> mockLeaguesMap(Map eventsPerDayMap, bool live){
    Map<String, List<LeagueWithData>> mockLeaguesMap = new LinkedHashMap();
    List<LeagueWithData> leagues = mockLeagues(eventsPerDayMap);
    mockLeaguesMap.putIfAbsent('-1', () => leagues);
    mockLeaguesMap.putIfAbsent('0', () => leagues);
    mockLeaguesMap.putIfAbsent('1', () => leagues);
    return mockLeaguesMap;
  }

  List<LeagueWithData> mockLeagues(Map eventsPerDayMap){
    List<int> existingLeaguesIds = <int>[];
    if (eventsPerDayMap.isNotEmpty && eventsPerDayMap['0'].isNotEmpty) {
      eventsPerDayMap['0']?.forEach((element) {
        existingLeaguesIds.add(element.league.league_id);
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

    List<LeagueWithData> leagues = <LeagueWithData>[];

    existingLeaguesIds.forEach((leagueId) {


      var events = <MatchEvent>[];
      Set<MatchEvent> eventsMock = mockEvents(leagueId);
      events.addAll(eventsMock);
      League leagueInfo = League(   name: "Mock country"+leagueId.toString(), league_id: leagueId, priority: leagueId, section_id: leagueId);
      LeagueWithData league = LeagueWithData(events: events,  league: leagueInfo);

      // for (MatchEvent event in eventsMock){
      //   if (MatchEventStatus.fromStatusText(event.status) == MatchEventStatus.INPROGRESS) {
      //     league.liveEvents.add(event);
      //   }
      // }

      league.league.logo = "https://xscore.cc/resb/league/europe-uefa-champions-league.png" ;

      // Section section = Section(name: "Section name"+leagueId.toString(), id: leagueId, slug: "slug", flag: "flfl", sport_id: 1);
      league.league.section_id = leagueId;

      leagues.add(league);

    });

    return leagues;
  }

  Set<MatchEvent> mockEvents(int leagueId) {
    List<Team> mockTeams = <Team>[];
    mockTeams.add(newTeam('panathinaikos________________________________________'+leagueId.toString()));
    mockTeams.add(newTeam('liverpool_'+leagueId.toString()));
    mockTeams.add(newTeam('benfica_'+leagueId.toString()));
    mockTeams.add(newTeam('olympiacos_'+leagueId.toString()));

    Set<MatchEvent> mockEvents = LinkedHashSet();
    MatchEvent mockEvent1 = mockEvent(mockTeams.elementAt(0), mockTeams.elementAt(1), 1+leagueId, 1.5, 3.4, 5.0, 1.95, 1.85, MatchEventStatus.INPROGRESS.statusStr, MatchEventStatusMore.INPROGRESS_2ND_HALF.statusStr, DateTime.now().millisecondsSinceEpoch-(12*60000), ChangeEvent.NONE, null);
    mockEvents.add(mockEvent1);
    MatchEvent mockEvent2 = mockEvent(mockTeams.elementAt(2), mockTeams.elementAt(3), 2+leagueId, 1.58, 4.4, 5.76, 1.95, 1.85, MatchEventStatus.NOTSTARTED.statusStr, MatchEventStatusMore.EMPTY.statusStr, 0, ChangeEvent.NONE, null);
    mockEvents.add(mockEvent2);
    MatchEvent mockEvent3 = mockEvent(mockTeams.elementAt(1), mockTeams.elementAt(0), 3+leagueId, 1.5, 3.4, 5.0, 1.95, 1.85, MatchEventStatus.INPROGRESS.statusStr, MatchEventStatusMore.INPROGRESS_1ST_EXTRA.statusStr, DateTime.now().millisecondsSinceEpoch-(6*60000), ChangeEvent.NONE, null);
    mockEvents.add(mockEvent3);

    MatchEvent mockEvent4 = mockEvent(mockTeams.elementAt(3), mockTeams.elementAt(2), 4+leagueId, 1.5, 3.4, 5.0, 1.95, 1.85, MatchEventStatus.FINISHED.statusStr, MatchEventStatusMore.AFTER_EXTRA_TIME.statusStr, 0, ChangeEvent.NONE, LastedPeriod.EXTRA_2.period);
    mockEvents.add(mockEvent4);
    return mockEvents;
  }

  MatchEvent mockEvent(team1, team2, eventId, odd1, oddx, odd2, oddO25, oddU25, _status, _status_more, int startMillis, _changeEvent, _lastedPeriod){
    TimeDetails? details = null;
    if (startMillis > 0){
      details = TimeDetails();
      details.currentPeriodStartTimestamp = startMillis;
    }
    MatchOdds mockOdds1 = mockOdds(team1, team2, eventId, odd1, oddx, odd2, oddO25, oddU25);

    MatchEvent event = MatchEvent(eventId: eventId, leagueId: 1, homeTeam: team1 , awayTeam : team2, status: _status, status_more: _status_more, start_at: '2022-10-13 15:00:00');
    event.timeDetails = details;
    event.odds = mockOdds1;
    event.lasted_period = _lastedPeriod;

    event.changeEvent = _changeEvent;

    if (! (MatchEventStatus.FINISHED.statusStr == _status)) {
      event.homeTeamScore = Score(1, 1, eventId, eventId, eventId);
      event.awayTeamScore = Score(1, 1, eventId, eventId, eventId);
    }else{
      event.homeTeamScore = Score(2, 1, eventId, eventId, eventId);
      event.awayTeamScore = Score(2, 1, eventId, eventId, eventId);

      event.winner_code = 3;
      event.aggregated_winner_code = 2;
    }

    int random = Random().nextInt(5);
    if (random == 1){
      event.homeTeamScore!.current = (event.homeTeamScore!.current)! + 1;
      event.changeEvent = ChangeEvent.HOME_GOAL;
    }else{
      event.changeEvent = ChangeEvent.NONE;
    }

   // event.incidents = mockStats();

    // event.calculateLiveMinute();
    return event;
  }

  MatchOdds mockOdds(team1, team2, eventId, _odd1, _oddx, _odd2, _oddO25, _oddU25){
    return MatchOdds(
        odd1: UserPrediction(change: 0, sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType: BetPredictionType.HOME_WIN, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId, value: _odd1),
        oddX: UserPrediction(change: 0,sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.DRAW, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _oddx),
        odd2: UserPrediction(change: 0,sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.AWAY_WIN, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _odd2),
        oddO25: UserPrediction(change: 0,sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.OVER_25, betPredictionStatus: BetPredictionStatus.PENDING,eventId: eventId,value: _oddO25),
        oddU25: UserPrediction(change: 0,sportId:1, homeTeam: team1, awayTeam: team2, betPredictionType:BetPredictionType.UNDER_25, betPredictionStatus: BetPredictionStatus.PENDING, eventId: eventId,value: _oddU25));
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
    Team t =  Team(Random().nextInt(10000000), teamName);
    t.logo = LOGO_BASE_URL + teamName.split('_')[0] + ".png";
    return t;
  }

  // pickTeam() {
  //   // try {
  //   //   return mockTeams.removeLast();
  //   // }catch (e){
  //     return Team(Random().nextInt(10000000), "mockTeam", 'https://tipsscore.com/resb/no-league.png');
  //   //}
  // }

  List<MatchEventIncidentSoccer> mockStats() {
    List<MatchEventIncidentSoccer> stats = <MatchEventIncidentSoccer>[];
    stats.add(mockStat(1, 1, "card", 1, null));
    stats.add(mockStat(4, 4, "goal", 2, null));
    stats.add(mockStat(6, 6, "substitution", 2, null));
    stats.add(mockStat(2, 2, "card", 1, null));
    stats.add(mockStat(5, 5, "card", 2, null));

    stats.add(mockStat(3, 45, MatchIncidentsConstants.PERIOD, null, "HT 0 - 0"));


    stats.sort();
    return stats;
  }

  MatchEventIncidentSoccer mockStat(int order, int time, String incident, int? team, String? text) {
    MatchEventIncidentSoccer stat = MatchEventIncidentSoccer(id: 1, event_id: 1, incident_type: incident, time: time, order: order);
    stat.player_team = team;
    stat.player = Player(has_photo: true, photo: "https://tipsscore.com/resb/player/sebastien-mladen.png",
    name: 'mockovic', id: 1, position: 'f', position_name: 'forward', sport_id: 1, name_short: 'mockovic');

    stat.player_two_in = Player(has_photo: true, photo: "https://tipsscore.com/resb/player/neymar.png",
        name: 'mockovic out ', id: 1, position: 'f', position_name: 'forward', sport_id: 1, name_short: 'mockovic out');

    stat.text = text;
    return stat;

  }

  static User mockUser() {
    User user = User("1234", "Mocker", <UserBet>[]);
    user.balance = UserMonthlyBalance.defBalance();

    user.overallLostBets=5;
    user.overallWonBets=12;
    user.overallLostPredictions=22;
    user.overallWonPredictions=32;
    return user;
  }

}