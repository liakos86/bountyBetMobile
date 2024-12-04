
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/TimeDetails.dart';
import 'package:flutter_app/models/constants/JsonConstants.dart';
import 'package:flutter_app/models/LeagueWithData.dart';
import 'package:flutter_app/models/League.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionStatus.dart';
import '../enums/BetPredictionType.dart';
import '../enums/MatchEventStatus.dart';
import '../models/Score.dart';
import '../models/Section.dart';
import '../models/Team.dart';
import '../models/UserPrediction.dart';
import '../models/context/AppContext.dart';
import '../models/match_odds.dart';

class JsonHelper{

  static Future<Set<MatchEvent>> eventsSetFromJson(var eventsJson) async{
    Set<MatchEvent> events = Set();
    for (var eventJson in eventsJson){
      MatchEvent event = await eventFromJson(eventJson);
      events.add(event);
    }

    return events;
  }

  static Future<MatchEvent> eventFromJson(var event) async{

    var homeTeam = event["home_team"];
    var awayTeam = event["away_team"];
    var homeTeamScore = event["home_score"];
    var awayTeamScore = event["away_score"];
    var changeEvent = event["changeEvent"] as int;
    int? sportId = event['sportId'];
    sportId ??= 1;


    Team hTeam = Team(homeTeam[JsonConstants.id], homeTeam["name"], homeTeam["logo"]);
    Team aTeam = Team(awayTeam[JsonConstants.id], awayTeam["name"], awayTeam["logo"]);

    if (homeTeam['name_translations'] != null){
      hTeam.name_translations = homeTeam['name_translations'];
    }

    if (awayTeam['name_translations'] != null){
      aTeam.name_translations = awayTeam['name_translations'];
    }

    var startAt = event['start_at'];
    MatchEvent match = MatchEvent(eventId: event[JsonConstants.id], leagueId: event[JsonConstants.leagueId], status: event["status"], status_more: event["status_more"]??'-', homeTeam: hTeam, awayTeam: aTeam, start_at: startAt);
    match.changeEvent = ChangeEvent.ofCode(changeEvent);



    var eventOdds = event["main_odds"];
    if (eventOdds != null) {
      var outcome1 = eventOdds["outcome_1"];
      var outcome1Value = outcome1["value"];

      var outcomeX = eventOdds["outcome_X"];
      var outcomeXValue = outcomeX["value"];

      var outcome2 = eventOdds["outcome_2"];
      var outcome2Value = outcome2["value"];

       MatchOdds odds = MatchOdds(
          oddO25: UserPrediction(eventId: event[JsonConstants.id],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.OVER_25,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          oddU25: UserPrediction(eventId: event[JsonConstants.id],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.UNDER_25,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          odd1: UserPrediction(eventId: event[JsonConstants.id],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.HOME_WIN,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          //.toString().replaceAll(',', '.')),
          oddX: UserPrediction(eventId: event[JsonConstants.id],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.DRAW,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcomeXValue),
          odd2: UserPrediction(eventId: event[JsonConstants.id],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.AWAY_WIN,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome2Value));

      match.odds = odds;
    }

   if (homeTeamScore != null){
      match.homeTeamScore = Score(homeTeamScore["current"], homeTeamScore["display"], homeTeamScore["normal_time"],
          homeTeamScore["period_1"], homeTeamScore["period_2"]);
    }

    if (awayTeamScore != null){
      match.awayTeamScore = Score(awayTeamScore["current"], awayTeamScore["display"], awayTeamScore["normal_time"],
          awayTeamScore["period_1"], awayTeamScore["period_2"]);
    }

    match.timeDetails = TimeDetails.fromJson(event['time_details']);

    // the last period of the match e.g. extra_2 means the match ended in extra time.
    match.lasted_period = event['lasted_period'];

    //winner code based on Score.aggregatedScore , i.e. the winner or qualified team.
    match.aggregated_winner_code = event['aggregated_winner_code'];

    //the match winner code after all played periods. counts extra time and penalties.
    match.winner_code = event['winner_code'];

    List<String> favEvents = await sharedPrefs.getListByKey(sp_fav_event_ids);
    if (favEvents.contains(match.eventId.toString())){
      match.isFavourite = true;
    }

    // match.calculateLiveMinute();
    return match;
  }

  static Future<LeagueWithData?> leagueWithDataFromJson(leagueWithDataJson) async{

    List<MatchEvent> matches = <MatchEvent>[];
    // List<MatchEvent> liveMatches = <MatchEvent>[];

    var jsonLeagueEvents = leagueWithDataJson["matchEvents"];
    for (var jsonEvent in jsonLeagueEvents){
      if (jsonEvent[JsonConstants.id] == null || jsonEvent[JsonConstants.id] == -1 || jsonEvent[JsonConstants.id].toString() == '-1'){
        continue;
      }

      MatchEvent match = await eventFromJson(jsonEvent);
      matches.add(match);
      // if (MatchEventStatus.INPROGRESS == MatchEventStatus.fromStatusText(match.status)){
      //   liveMatches.add(match);
      // }
    }

    // var league = leagueWithDataJson['league'];
    int leagueId = leagueWithDataJson['leagueId'];

    if(!AppContext.allLeaguesMap.containsKey(leagueId)){
      print('League missing ' + leagueId.toString());
      return null;
    }

    League li = AppContext.allLeaguesMap[leagueId];

    LeagueWithData l = LeagueWithData(
        league: li,
        events: matches);
    // l.liveEvents = liveMatches;

    return l;
  }


  static League leagueFromJson(league){
    League li = League(
        name: league[JsonConstants.name],
        league_id: league[JsonConstants.id],
        has_logo: league[JsonConstants.hasLogo],
        priority: league[JsonConstants.priority]
    );

    var sectionJson = league[JsonConstants.section];
    if (sectionJson != null) {
      Section section = Section(sectionJson[JsonConstants.name]);
      li.section = section;
    }

    li.logo = league[JsonConstants.logo];

    List<int> leagueSeasonIds = <int>[];
    var seasonsJson = league['seasonIds'];
    if (seasonsJson != null ){
      for (int seasonJson in seasonsJson) {
        leagueSeasonIds.add(seasonJson);
      }
    }

    li.seasonIds = leagueSeasonIds;

    return li;
  }

}