enum BetPredictionCategory{

  FINAL_RESULT(categoryCode: 1),

  OVER_UNDER(categoryCode: 2);

  final int categoryCode;

  const BetPredictionCategory({
    required this.categoryCode
  })  ;

}