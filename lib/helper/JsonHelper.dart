
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
      MatchEvent event = await MatchEvent.eventFromJson(eventJson);
      events.add(event);
    }

    return events;
  }



  // static Future<LeagueWithData?> leagueWithDataFromJson(leagueWithDataJson) async{
  //
  //   List<MatchEvent> matches = <MatchEvent>[];
  //   // List<MatchEvent> liveMatches = <MatchEvent>[];
  //
  //   var jsonLeagueEvents = leagueWithDataJson["matchEvents"];
  //   for (var jsonEvent in jsonLeagueEvents){
  //     if (jsonEvent[JsonConstants.id] == null || jsonEvent[JsonConstants.id] == -1 || jsonEvent[JsonConstants.id].toString() == '-1'){
  //       continue;
  //     }
  //
  //     MatchEvent match = await MatchEvent. eventFromJson(jsonEvent);
  //     matches.add(match);
  //     // if (MatchEventStatus.INPROGRESS == MatchEventStatus.fromStatusText(match.status)){
  //     //   liveMatches.add(match);
  //     // }
  //   }
  //
  //   // var league = leagueWithDataJson['league'];
  //   int leagueId = leagueWithDataJson['leagueId'];
  //
  //   if(!AppContext.allLeaguesMap.containsKey(leagueId)){
  //     print('League missing ' + leagueId.toString());
  //     return null;
  //   }
  //
  //   League? le = AppContext.allLeaguesMap[leagueId];
  //
  //   LeagueWithData l = LeagueWithData(
  //       league: le??League.defConst(),
  //       events: matches);
  //   // l.liveEvents = liveMatches;
  //
  //   return l;
  // }




}