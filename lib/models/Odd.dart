import 'dart:ui';

import 'package:flutter_app/enums/BetPredictionType.dart';

class Odd{

  BetPredictionType betPredictionType;

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

}