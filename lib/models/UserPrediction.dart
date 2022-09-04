import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';

import '../enums/BetPredictionStatus.dart';

class UserPrediction{

  BetPredictionType? betPredictionType;

  BetPredictionStatus betPredictionStatus = BetPredictionStatus.PENDING;

  int eventId;

  double value;

  //UserPrediction.ofNull(this.eventId, this.value);

  UserPrediction({
    required this.betPredictionType,
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
    return UserPrediction(eventId: parsedJson['eventId'],
        value: parsedJson['oddValue'] as double,
        betPredictionType:  BetPredictionType.of(int.parse(parsedJson['predictionCategory']), int.parse(parsedJson['predictionType'])));
  }

}