import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/helper/JsonHelper.dart';
import 'package:flutter_app/models/match_event.dart';

import '../enums/BetPredictionStatus.dart';

class UserPrediction{

  BetPredictionType? betPredictionType;

  BetPredictionStatus betPredictionStatus = BetPredictionStatus.PENDING;

  int eventId;

  MatchEvent? event;

  double value;

  UserPrediction({
    required this.betPredictionType,
    required this.betPredictionStatus,
    required this.eventId,
    required this.value
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
    UserPrediction prediction = UserPrediction(eventId: parsedJson['eventId'],
        value: parsedJson['oddValue'] as double,
        betPredictionStatus: BetPredictionStatus.ofStatus(int.parse(parsedJson['predictionStatus'])),
        betPredictionType:  BetPredictionType.of(int.parse(parsedJson['predictionCategory']), int.parse(parsedJson['predictionType'])));
    prediction.event = JsonHelper.eventFromJson(parsedJson['event']);
    return prediction;
  }

}