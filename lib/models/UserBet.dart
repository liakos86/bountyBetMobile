import 'dart:convert';

import '../enums/BetStatus.dart';
import 'Odd.dart';

class UserBet{

  String userMongoId;

  List<Odd> selectedOdds;

  double betAmount;

  BetStatus betStatus = BetStatus.PENDING;

  UserBet({
    required this.userMongoId,
    required this.selectedOdds,
    required this.betAmount
  } );

  /*
   * No need to send a status, server will always set it to PENDING.
   */
  Map<String, dynamic> toJson() {
    return {
      'mongoUserId': this.userMongoId,
      'betAmount': this.betAmount.toString(),
      'predictions' : jsonEncode(this.selectedOdds)
    };
  }


}