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