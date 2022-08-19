enum BetPredictionCategory{

  FINAL_RESULT(categoryCode: 1),

  OVER_UNDER(categoryCode: 2);

  final int categoryCode;

  const BetPredictionCategory({
    required this.categoryCode
  })  ;

  static BetPredictionCategory? of(int code){
    for (BetPredictionCategory category in BetPredictionCategory.values){
      if (code == category.categoryCode){
        return category;
      }
    }
    return null;
  }

}