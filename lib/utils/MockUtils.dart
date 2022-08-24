import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/models/match_odds.dart';

import '../models/UserPrediction.dart';
import '../models/league.dart';


class MockUtils {

  List<League> mockLeagues() {
    List<League> mockLeagues = <League>[];
    List<MatchEvent> mockEvents = <MatchEvent>[];
    MatchEvent mockEvent1 = mockEvent('1', 1.5, 3.4, 5.0, 1.95, 1.85);
    mockEvents.add(mockEvent1);
    MatchEvent mockEvent2 = mockEvent('2', 1.58, 4.4, 5.76, 1.95, 1.85);
    mockEvents.add(mockEvent2);
    MatchEvent mockEvent3 = mockEvent('3', 1.75, 3.1, 6.5, 1.95, 1.85);
    mockEvents.add(mockEvent3);
    MatchEvent mockEvent4 = mockEvent('4', 1.75, 3.1, 6.5, 1.95, 1.85);
    mockEvents.add(mockEvent4);
    MatchEvent mockEvent5 = mockEvent('5', 1.75, 3.1, 6.5, 1.95, 1.85);
    mockEvents.add(mockEvent5);
    MatchEvent mockEvent6 = mockEvent('6', 1.75, 3.1, 6.5, 1.95, 1.85);
    mockEvents.add(mockEvent6);

    League mockLeague = League(league_id: '1', country_name: 'Greece', country_id: '1', league_name: 'Super League', events: mockEvents);
    mockLeagues.add(mockLeague);
    return mockLeagues;
  }

  MatchEvent mockEvent(eventId, odd1, oddx, odd2, oddO25, oddU25){
    MatchOdds mockOdds1 = mockOdds(eventId, odd1, oddx, odd2, oddO25, oddU25);
    MatchEvent event = MatchEvent(eventId: eventId, homeTeam: "home team " + eventId, awayTeam : "away team " + eventId, odds: mockOdds1);
    return event;
  }

  MatchOdds mockOdds(eventId, odd1, oddx, odd2, oddO25, oddU25){
    return MatchOdds(
        odd1: UserPrediction(betPredictionType: BetPredictionType.HOME_WIN, eventId: eventId, value: odd1),
        oddX: UserPrediction(betPredictionType:BetPredictionType.DRAW, eventId: eventId,value: oddx),
        odd2: UserPrediction(betPredictionType:BetPredictionType.AWAY_WIN, eventId: eventId,value: odd2),
        oddO25: UserPrediction(betPredictionType:BetPredictionType.OVER_25, eventId: eventId,value: oddO25),
        oddU25: UserPrediction(betPredictionType:BetPredictionType.UNDER_25, eventId: eventId,value: oddU25));
  }

  User mockUser(List<League> validData) {
    League firstLeague = validData.first;
    List<UserBet> userBets = <UserBet>[];


    for (int j=3;j>0;j--) {

      List<UserPrediction> predictions = <UserPrediction>[];
      UserBet bet = UserBet(userMongoId: "62ff5c5988a49a2e2a3ed9aa",
          predictions: predictions,
          betAmount: 5);
      for (int i = 1; i < 4; i++) {
        UserPrediction prediction = UserPrediction(
            betPredictionType: BetPredictionType.of(1, i), eventId: firstLeague
            .getEvents()
            .getRange(i, i+1)
            .first
            .eventId, value: (2.1 + i));
        prediction.betPredictionStatus = BetPredictionStatus.ofStatus(i);
        predictions.add(prediction);
      }
      bet.betStatus = BetStatus.ofStatus(j);
      userBets.add(bet);
    }
    return new User("mockUser", 1200, userBets);
  }

}