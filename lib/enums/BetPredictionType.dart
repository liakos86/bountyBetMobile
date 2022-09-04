import 'package:flutter_app/enums/BetPredictionCategory.dart';

enum BetPredictionType {
  HOME_WIN(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 1, text: "1: "),
  AWAY_WIN(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 2, text: "2: "),
  DRAW(betPredictionCategory: BetPredictionCategory.FINAL_RESULT, betPredictionCode: 3, text: "X: "),
  OVER_25(betPredictionCategory: BetPredictionCategory.OVER_UNDER, betPredictionCode: 4, text: "Over 2.5: "),
  UNDER_25(betPredictionCategory: BetPredictionCategory.OVER_UNDER, betPredictionCode: 5, text: "Under 2.5: ");

  final BetPredictionCategory betPredictionCategory;

  final int betPredictionCode;

  final String text;

  const BetPredictionType({
    required this.betPredictionCategory,
    required this.betPredictionCode,
    required this.text
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