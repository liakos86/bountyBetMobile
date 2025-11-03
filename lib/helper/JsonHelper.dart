
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





}