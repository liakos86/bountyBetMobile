import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';

import '../models/Odd.dart';
import '../models/league.dart';


class MockUtils {

  List<League> mockLeagues() {
    List<League> mockLeagues = <League>[];
    MatchOdds mockOdds = MatchOdds(odd1: Odd(betPredictionType: BetPredictionType.homeWin, matchId: '1', value: '1.7'), oddX: Odd(betPredictionType:BetPredictionType.draw, matchId: '1',value:'4.22'), odd2: Odd(betPredictionType:BetPredictionType.awayWin, matchId: '1',value:'5'));
    MatchEvent mockEvent = MatchEvent(eventId: '1', homeTeam: "home team", awayTeam : "away team", odds: mockOdds);
    List<MatchEvent> mockEvents = <MatchEvent>[];
    mockEvents.add(mockEvent);
    League mockLeague = League(league_id: '1', country_name: 'Greece', country_id: '1', league_name: 'Super League', events: mockEvents);
    mockLeagues.add(mockLeague);
    return mockLeagues;
  }

}