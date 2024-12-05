import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../League.dart';
import '../LeagueWithData.dart';
import '../Section.dart';
import '../User.dart';

class AppContext{

  /*
   * Map with all the supported sections.
   */
  static final Map allSectionsMap = HashMap<int, Section>();

  /*
   * Map with all the supported leagues.
   */
  static final Map allLeaguesMap = HashMap<int, League>();

  /*
   * Map with keys the dates and values the List of leagues for each date.
   */
  static final Map eventsPerDayMap = HashMap<String, List<LeagueWithData>>();

  /*
   * All the leagues with matches etc. All the values of the map above are included here.
   */
//  static final List<LeagueWithData> allLeaguesWithData = <LeagueWithData>[];

  /*
   * The leagues which contain live games, only with the live games.
   */
  static final List<LeagueWithData> liveLeagues = <LeagueWithData>[];

  /*
   * The logged user.
   */
  static User user = User.defUser();

  AppContext();

  void initUser(User userNew){
    user = userNew;
  }

  static void updateUser(User value) {
    user.username = value.username;
    user.userBets.clear();
    user.userBets.addAll(value.userBets);
    user.validated = value.validated;

    user.email = value.email;
    user.balance = value.balance;
    user.mongoUserId = value.mongoUserId;
    user.errorMessage = value.errorMessage;
    user.userPosition = value.userPosition;
  }


}