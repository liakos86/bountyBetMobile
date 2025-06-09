import 'UserPrediction.dart';

class MatchOdds {

  MatchOdds({

    required this.odd1,
    required this.oddX,
    required this.odd2,
    required this.oddO25,
    required this.oddU25

});

  UserPrediction odd1;

  UserPrediction odd2;

  UserPrediction oddX;

  UserPrediction oddO25;

  UserPrediction oddU25;

  void copyFrom(MatchOdds? odds) {
    odd1.copyFrom(odds!.odd1);
    odd2.copyFrom(odds.odd2);
    oddX.copyFrom(odds.oddX);
  }

}