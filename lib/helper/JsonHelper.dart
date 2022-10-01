import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionType.dart';
import '../models/Score.dart';
import '../models/Team.dart';
import '../models/UserPrediction.dart';
import '../models/match_odds.dart';

class JsonHelper{

  static MatchEvent eventFromJson(var event){
    MatchOdds odds ;

    var eventOdds = event["main_odds"];

    if (eventOdds != null) {
      var outcome1 = eventOdds["outcome_1"];
      var outcome1Value = outcome1["value"];

      var outcomeX = eventOdds["outcome_X"];
      var outcomeXValue = outcomeX["value"];

      var outcome2 = eventOdds["outcome_2"];
      var outcome2Value = outcome2["value"];

      odds = MatchOdds(
          oddO25: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.OVER_25,
              value: outcome1Value),
          oddU25: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.UNDER_25,
              value: outcome1Value),
          odd1: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.HOME_WIN,
              value: outcome1Value),
          //.toString().replaceAll(',', '.')),
          oddX: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.DRAW,
              value: outcomeXValue),
          //.toString().replaceAll(',', '.')),
          odd2: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.AWAY_WIN,
              value: outcome2Value)); //.toString().replaceAll(',', '.')));
    }else{
      odds = MatchOdds(
          oddO25: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.OVER_25,
              value: -1),
          oddU25: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.UNDER_25,
              value: -1),
          odd1: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.HOME_WIN,
              value: -1),
          //.toString().replaceAll(',', '.')),
          oddX: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.DRAW,
              value: -1),
          //.toString().replaceAll(',', '.')),
          odd2: UserPrediction(eventId: event["id"],
              betPredictionType: BetPredictionType.AWAY_WIN,
              value: -1));
    }

    var homeTeam = event["home_team"];
    var awayTeam = event["away_team"];
    var homeTeamScore = event["home_score"];
    var awayTeamScore = event["away_score"];
    var _changeEvent = event["changeEvent"];

    MatchEvent match = MatchEvent(eventId: event["id"],
        status: event["status"],

        homeTeam: Team(homeTeam["id"], homeTeam["name"], homeTeam["logo"]),
        awayTeam: Team(awayTeam["id"], awayTeam["name"], awayTeam["logo"]),

        odds: odds,

    );
    //print(_changeEvent);
   match.changeEvent = ChangeEvent.ofCode(_changeEvent);
    match.status_more = event["status_more"];
    match.status_for_client = event["status_for_client"];
    if (homeTeamScore != null){
      match.homeTeamScore = Score(homeTeamScore["current"], homeTeamScore["display"], homeTeamScore["normal_time"],
          homeTeamScore["period_1"], homeTeamScore["period_2"]);

    }

    if (awayTeamScore != null){
      match.awayTeamScore = Score(awayTeamScore["current"], awayTeamScore["display"], awayTeamScore["normal_time"],
          awayTeamScore["period_1"], awayTeamScore["period_2"]);
    }

    return match;
  }

  static League leagueFromJson(league) {
    List<MatchEvent> matches = <MatchEvent>[];
    var jsonLeagueEvents = league["liveMatchEvents"];
    for (var jsonEvent in jsonLeagueEvents){
      MatchEvent match = eventFromJson(jsonEvent);
      matches.add(match);
    }

    print('GOT EVENTS');
    League l = League(
        name: league['name'],
        league_id: league['id'],
        has_logo: league['has_logo'],
        events: matches);

    l.logo = league['logo'];

    return l;
  }

}