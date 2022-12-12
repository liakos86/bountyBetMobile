import 'dart:convert';

import 'package:flutter_app/models/UserBet.dart';

class User{

  User.defUser();

  User(this.username, this.balance, this.userBets);

  /*
   * Currently testing with same user everywhere.
   */
  String? mongoUserId;//'''62ff5c5988a49a2e2a3ed9aa';

  String username = '';

  String email = '';

  String errorMessage = '';

  double balance = -1;

  List<UserBet> userBets = <UserBet>[];

  static User fromJson(Map<String, dynamic> parsedJson){
    if (parsedJson['errorMessage'] != null) {
      User user  = User.defUser();
      user.errorMessage = parsedJson['errorMessage'];
      return user;
    }


    User user = User(parsedJson['username'].toString(), parsedJson['balance'] as double,
        (parsedJson['userBets'] as List)
            .map((data) =>  UserBet.fromJson(data))
            .toList()
           );

    user.mongoUserId = parsedJson['mongoId'];
    user.email = parsedJson['email'];


    return user;

  }

}