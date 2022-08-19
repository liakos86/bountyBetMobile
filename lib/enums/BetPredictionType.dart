import 'package:flutter_app/enums/BetPredictionCategory.dart';

enum BetPredictionType {
  homeWin(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 1),
  awayWin(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 2),
  draw(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 3);

  final BetPredictionCategory betPredictionCategory;

  final int betPredictionCode;

  const BetPredictionType({
    required this.betPredictionCategory,
    required this.betPredictionCode
  });

}