import 'package:flutter_app/enums/BetPredictionCategory.dart';

enum BetPredictionType {
  HOME_WIN(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 1),
  AWAY_WIN(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 2),
  DRAW(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 3),
  OVER_25(betPredictionCategory: BetPredictionCategory.OVER_UNDER, betPredictionCode: 4),
  UNDER_25(betPredictionCategory: BetPredictionCategory.OVER_UNDER, betPredictionCode: 5);

  final BetPredictionCategory betPredictionCategory;

  final int betPredictionCode;

  const BetPredictionType({
    required this.betPredictionCategory,
    required this.betPredictionCode
  });

  static BetPredictionType? of(int category, int type){
      BetPredictionCategory? predictionCategory = BetPredictionCategory.of(category);
      for (BetPredictionType predictionType in BetPredictionType.values){
        if (predictionType.betPredictionCategory == predictionCategory && predictionType.betPredictionCode == type){
          return predictionType;
        }
      }
      return null;
  }

}