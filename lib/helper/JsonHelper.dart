
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/Player.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/models/league.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionStatus.dart';
import '../enums/BetPredictionType.dart';
import '../enums/MatchEventStatus.dart';
import '../models/Score.dart';
import '../models/Season.dart';
import '../models/Section.dart';
import '../models/Standing.dart';
import '../models/Team.dart';
import '../models/UserPrediction.dart';
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
    var _changeEvent = event["changeEvent"] as int;
    int? sportId = event['sportId'];
    sportId ??= 1;


    Team hTeam = Team(homeTeam["id"], homeTeam["name"], homeTeam["logo"]);
    Team aTeam = Team(awayTeam["id"], awayTeam["name"], awayTeam["logo"]);

    if (homeTeam['name_translations'] != null){
      hTeam.name_translations = homeTeam['name_translations'];
    }

    if (awayTeam['name_translations'] != null){
      aTeam.name_translations = awayTeam['name_translations'];
    }

    var startAt = event['start_at'];
    MatchEvent match = MatchEvent(eventId: event["id"], status: event["status"], status_more: event["status_more"]??'-', homeTeam: hTeam, awayTeam: aTeam, start_at: startAt);
    match.changeEvent = ChangeEvent.ofCode(_changeEvent);

    match.calculateLiveMinute();

    var eventOdds = event["main_odds"];
    if (eventOdds != null) {
      var outcome1 = eventOdds["outcome_1"];
      var outcome1Value = outcome1["value"];

      var outcomeX = eventOdds["outcome_X"];
      var outcomeXValue = outcomeX["value"];

      var outcome2 = eventOdds["outcome_2"];
      var outcome2Value = outcome2["value"];

       MatchOdds odds = MatchOdds(
          oddO25: UserPrediction(eventId: event["id"],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.OVER_25,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          oddU25: UserPrediction(eventId: event["id"],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.UNDER_25,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          odd1: UserPrediction(eventId: event["id"],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.HOME_WIN,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome1Value),
          //.toString().replaceAll(',', '.')),
          oddX: UserPrediction(eventId: event["id"],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.DRAW,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcomeXValue),
          //.toString().replaceAll(',', '.')),
          odd2: UserPrediction(eventId: event["id"],
              sportId: sportId,
              homeTeam: hTeam,
              awayTeam: aTeam,
              betPredictionType: BetPredictionType.AWAY_WIN,
              betPredictionStatus: BetPredictionStatus.PENDING,
              value: outcome2Value)); //.toString().replaceAll(',', '.')));

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

    var matchIncidents = event['incidents'];
    if (matchIncidents != null){
       match.incidents = incidentsFromJson(matchIncidents);
    }

    var matchStats = event['statistics'];
    if (matchStats != null){
      match.statistics = statsFromJson(matchStats);
    }

    List<String> favEvents = await sharedPrefs.getListByKey(sp_fav_event_ids);
    if (favEvents.contains(match.eventId.toString())){
      match.isFavourite = true;
    }

    return match;
  }

  static Future<League> leagueFromJson(league) async{
    List<MatchEvent> matches = <MatchEvent>[];
    List<MatchEvent> liveMatches = <MatchEvent>[];

    var jsonLeagueEvents = league["matchEvents"];
    for (var jsonEvent in jsonLeagueEvents){
      if (jsonEvent['id'] == null || jsonEvent['id'] == -1 || jsonEvent['id'].toString() == '-1'){
        continue;
      }

      MatchEvent match = await eventFromJson(jsonEvent);
      matches.add(match);
      if (MatchEventStatus.INPROGRESS == MatchEventStatus.fromStatusText(match.status)){
        liveMatches.add(match);
      }
    }

    League l = League(
        name: league['name'],
        league_id: league['id'],
        has_logo: league['has_logo'],
        priority: league['priority'],
        events: matches);
    l.liveEvents = liveMatches;

    l.logo = league['logo'];

    var sectionJson = league['section'];
    if (sectionJson != null) {
      Section section = Section(sectionJson['name']);
      l.section = section;
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
      if (teamJson['name_translations'] != null){
        hTeam.name_translations = teamJson['name_translations'];
      }

      StandingRow row = StandingRow(team: hTeam);
      row.away_points = stRow['away_points'];
      row.home_points = stRow['home_points'];
      row.position = stRow['position'];
      rows.add(row);
    }

    return Standing(standingRows: rows);

  }

  static List<MatchEventIncidentsSoccer> incidentsFromJson(matchIncidentsWrapperJson) {
    List<MatchEventIncidentsSoccer> incidents = <MatchEventIncidentsSoccer>[];

    var matchIncidentsJson = matchIncidentsWrapperJson['data'];
    for (var incidentJson in matchIncidentsJson){
      MatchEventIncidentsSoccer incident = MatchEventIncidentsSoccer(
          id: incidentJson['id'],
          event_id: incidentJson['event_id'],
          incident_type: incidentJson['incident_type'],
          time: incidentJson['time'],
          order: incidentJson['order'],
          );

      incident.text = incidentJson['text'];

      incident.card_type = incidentJson['card_type'];

      incident.scoring_team = incidentJson['scoring_team'];
      incident.reason = incidentJson['reason'];
      incident.player_team = incidentJson['player_team'];
      incident.scoring_team = incidentJson['scoring_team'];
      incident.home_score = incidentJson['home_score'];
      incident.away_score = incidentJson['away_score'];

      incident.player = playerFromJson(incidentJson['player']);
      incident.player_two_in = playerFromJson(incidentJson['player_two_in']);

      incidents.add(incident);
    }

    incidents.sort();
    return incidents;
  }

  static Player? playerFromJson(playerJson) {
    if (playerJson == null){
      return null;
    }

    Player player = Player(id: playerJson['id'],
        sport_id: playerJson['sport_id'],
        name: playerJson['name'],
        name_short: playerJson['name_short'],
        position: playerJson['position'],
        has_photo: playerJson['has_photo'],
        photo: playerJson['photo'],
        position_name: playerJson['position_name']);
    return player;
  }

  static List<MatchEventStatisticsSoccer> statsFromJson(matchStatsWrapperJson) {
    List<MatchEventStatisticsSoccer> stats = <MatchEventStatisticsSoccer>[];

    var matchStatsJson = matchStatsWrapperJson['data'];
    for (var statJson in matchStatsJson){
      MatchEventStatisticsSoccer stat = MatchEventStatisticsSoccer(
        id: statJson['id'],
        group: statJson['group'],
        period: statJson['period'],
        home: statJson['home'],
        away: statJson['away'],
        compare_code: statJson['compare_code']
      );

      stats.add(stat);
    }

    return stats;
  }

}