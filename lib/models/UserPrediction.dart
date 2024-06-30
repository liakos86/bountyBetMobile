import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/helper/JsonHelper.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionStatus.dart';
import 'Team.dart';
import 'constants/JsonConstants.dart';

class UserPrediction{

  BetPredictionType? betPredictionType;

  BetPredictionStatus betPredictionStatus = BetPredictionStatus.PENDING;

  Team homeTeam;

  Team awayTeam;

  int eventId;

  int sportId;

  double value;

  UserPrediction({
    required this.betPredictionType,
    required this.betPredictionStatus,
    required this.eventId,
    required this.value,
    required this.homeTeam,
    required this.awayTeam,
    required this.sportId
  });

  @override
  operator ==(other) =>
      other is UserPrediction &&
          other.eventId == eventId &&
              other.betPredictionType == betPredictionType;

  @override
  int get hashCode => hashValues(eventId, betPredictionType);

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
        homeTeam: Team(homeTeam[JsonConstants.id], homeTeam["name"], homeTeam["logo"]),
        awayTeam: Team(awayTeam[JsonConstants.id], awayTeam["name"], awayTeam["logo"]),
        sportId: parsedJson['sportId'] as int
    );

    return prediction;
  }

}