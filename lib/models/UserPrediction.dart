import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/helper/JsonHelper.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionStatus.dart';
import 'Team.dart';
import 'constants/Constants.dart';
import 'constants/JsonConstants.dart';

class UserPrediction{

  MatchEvent? event;
  
  UserPrediction.defPrediction();

  String mongoId = Constants.defMongoId;
  
  BetPredictionType? betPredictionType;

  BetPredictionStatus betPredictionStatus = BetPredictionStatus.PENDING;

  Team homeTeam = Team.defTeam();

  Team awayTeam = Team.defTeam();

  int eventId = -1;

  int sportId = 1;

  double value = 0;

  int change = 0;

  UserPrediction({
    required this.betPredictionType,
    required this.betPredictionStatus,
    required this.eventId,
    required this.value,
    required this.homeTeam,
    required this.awayTeam,
    required this.sportId,
    required this.change
  });

  @override
  operator ==(other) =>
      other is UserPrediction &&
          other.eventId == eventId &&
              other.betPredictionType == betPredictionType;

  @override
  int get hashCode => Object.hash(eventId, betPredictionType);

  /*
   * We don't need to set a prediction status, the server will always set it to PENDING.
   */
  Map<String, dynamic> toJson() {
    return {
      'eventId': this.eventId,
      'predictionType' : this.betPredictionType?.betPredictionCode.toString(),
      'predictionCategory' : this.betPredictionType?.betPredictionCategory.categoryCode.toString(),
      'oddValue' : this.value
    };
  }

  static UserPrediction fromJson(Map<String, dynamic> parsedJson){

    var homeTeam = parsedJson["homeTeam"];
    var awayTeam = parsedJson["awayTeam"];

    UserPrediction prediction = UserPrediction(eventId: parsedJson['eventId'],
        value: parsedJson['oddValue'] as double,
        betPredictionStatus: BetPredictionStatus.ofStatus(int.parse(parsedJson['predictionStatus'])),
        betPredictionType:  BetPredictionType.of(int.parse(parsedJson['predictionCategory']), int.parse(parsedJson['predictionType'])),
        homeTeam: Team.fromJson(homeTeam),
        awayTeam: Team.fromJson(awayTeam),
        sportId: parsedJson['sportId'] as int,
        change: parsedJson['change']!= null ? parsedJson['change'] as int : 0
    );

    return prediction;
  }

  void copyFrom(UserPrediction incoming) {
    betPredictionStatus = incoming.betPredictionStatus;
    value = incoming.value;
    change = incoming.change;
  }

}