
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionType.dart';
import '../models/Score.dart';
import '../models/Season.dart';
import '../models/Section.dart';
import '../models/Standing.dart';
import '../models/Team.dart';
import '../models/UserPrediction.dart';
import '../models/match_odds.dart';

class JsonHelper{

  static MatchEvent eventFromJson(var event, BuildContext context){
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
    var startHour = event["start_hour"];
    var startMinute = event["start_minute"];


    var homeTranslations = homeTeam['name_translations'];
    var awayTranslations = awayTeam['name_translations'];
    String langCode = Localizations.localeOf(context).languageCode;

    Team hTeam = Team(homeTeam["id"], homeTeam["name"], homeTeam["logo"]);
    Team aTeam = Team(awayTeam["id"], awayTeam["name"], awayTeam["logo"]);

    if (homeTranslations !=null && homeTranslations[langCode] != null){
      hTeam.name = homeTranslations[langCode];
    }

    if (awayTranslations != null && awayTranslations[langCode] != null){
      aTeam.name = awayTranslations[langCode];
    }

    MatchEvent match = MatchEvent(eventId: event["id"], status: event["status"], homeTeam: hTeam, awayTeam: aTeam, odds: odds);


   match.changeEvent = ChangeEvent.ofCode(_changeEvent);
   match.startHour = startHour;
   match.startMinute = startMinute;


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

  static League leagueFromJson(league, BuildContext context) {
    List<MatchEvent> matches = <MatchEvent>[];

    var jsonLeagueEvents = league["liveMatchEvents"];
    for (var jsonEvent in jsonLeagueEvents){
      MatchEvent match = eventFromJson(jsonEvent, context);
      matches.add(match);
    }

    League l = League(
        name: league['name'],
        league_id: league['id'],
        has_logo: league['has_logo'],
        events: matches);

    l.logo = league['logo'];
    var sectionJson = league['section'];

    Section section = Section(sectionJson['name']);
    var sectionTranslations = sectionJson['name_translations'];
    String langCode = Localizations.localeOf(context).languageCode;
    if (sectionTranslations != null && sectionTranslations[langCode] != null){
      section.name = sectionTranslations[langCode];
    }

    l.section = section;

    var translations = league['name_translations'];
    if (translations != null && translations[langCode] != null){
      l.name = translations[langCode];
    }


    var seasonsJson = league['seasons'];

    if (seasonsJson == null ){

    }else {
      for (var seasonJson in seasonsJson) {
        Season season = seasonFromJson(seasonJson);
        l.seasons.add(season);
      }
    }

    return l;
  }

  static seasonFromJson(seasonJson) {

    Standing st = standingFromJson(seasonJson['standing']);

    Season s = Season(year_start: seasonJson['year_start'], year_end: seasonJson['year_end'], standing: st);
    return s;

  }

  static Standing standingFromJson(standing) {
    List<StandingRow> rows = <StandingRow>[];

    //var standing = seasonJson['standing'];

    var stRows = standing['standings_rows'];
    for (var stRow in stRows){
      var teamJson = stRow['team'];
      Team hTeam = Team(teamJson["id"], teamJson["name"], teamJson["logo"]);
      StandingRow row = StandingRow(team: hTeam);
      row.away_points = stRow['away_points'];
      row.home_points = stRow['home_points'];
      row.position = stRow['position'];
      rows.add(row);
    }

    return Standing(standingRows: rows);

  }


}