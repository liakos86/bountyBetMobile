import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';

import '../enums/BetPredictionStatus.dart';

class Odd{

  BetPredictionType betPredictionType;

  BetPredictionStatus betPredictionStatus = BetPredictionStatus.PENDING;

  String matchId;

  String value;

  Odd({
    required this.betPredictionType,
    required this.matchId,
    required this.value
  });

  @override
  operator ==(other) =>
      other is Odd &&
          other.matchId == matchId &&
              other.betPredictionType == betPredictionType;

  @override
  int get hashCode => hashValues(matchId, betPredictionType);

  /*
   * We don't need to set a prediction status, the server will always set it to PENDING.
   */
  Map<String, dynamic> toJson() {
    return {
      'eventId': this.matchId,
      'prediction' : this.betPredictionType.betPredictionCode.toString(),
      'oddValue' : this.value
    };
  }

}