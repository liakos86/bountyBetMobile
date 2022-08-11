import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';

import '../models/Odd.dart';
import '../models/league.dart';


class MockUtils {

  List<League> mockLeagues() {
    List<League> mockLeagues = <League>[];
    List<MatchEvent> mockEvents = <MatchEvent>[];
    MatchEvent mockEvent1 = mockEvent('1', '1.5', '3.4', '5');
    mockEvents.add(mockEvent1);
    MatchEvent mockEvent2 = mockEvent('2', '1.58', '4.4', '5.76');
    mockEvents.add(mockEvent2);
    MatchEvent mockEvent3 = mockEvent('3', '1.75', '3.1', '6.5');
    mockEvents.add(mockEvent3);

    League mockLeague = League(league_id: '1', country_name: 'Greece', country_id: '1', league_name: 'Super League', events: mockEvents);
    mockLeagues.add(mockLeague);
    return mockLeagues;
  }

  MatchEvent mockEvent(eventId, odd1, oddx, odd2){
    MatchOdds mockOdds1 = mockOdds(eventId, odd1, oddx, odd2);
    return MatchEvent(eventId: eventId, homeTeam: "home team " + eventId, awayTeam : "away team " + eventId, odds: mockOdds1);
  }

  MatchOdds mockOdds(eventId, odd1, oddx, odd2){
    return MatchOdds(odd1: Odd(betPredictionType: BetPredictionType.homeWin, matchId: eventId, value: odd1), oddX: Odd(betPredictionType:BetPredictionType.draw, matchId: eventId,value: oddx), odd2: Odd(betPredictionType:BetPredictionType.awayWin, matchId: eventId,value: odd2));
  }

}