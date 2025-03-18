import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../League.dart';
import '../LeagueWithData.dart';
import '../Section.dart';
import '../User.dart';
import '../match_event.dart';

class AppContext{

  /*
   * Map with all the supported sections.
   */
  static final Map allSectionsMap = HashMap<int, Section>();

  /*
   * Map with all the supported leagues.
   */
  static final Map<int, League> allLeaguesMap = HashMap<int, League>();

  /*
   * Map with keys the dates and values the List of leagues for each date.
   */
  static final Map eventsPerDayMap = HashMap<String, List<LeagueWithData>>();

  /*
   * The logged user.
   */
  static User user = User.defUser();

  AppContext();

  void initUser(User userNew){
    user = userNew;
  }

  static MatchEvent? findEvent(int eventId){

    for (MapEntry dayEntry in eventsPerDayMap.entries){
      for (LeagueWithData l in dayEntry.value){
        for (MatchEvent e in l.events){
          if (eventId == e.eventId){
            return e;
          }
        }
      }
    }

    return null;//eventsPerDayMap.entries.first.value.events.first;

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

    user.betAmountMonthly = value.betAmountMonthly;
    user.betAmountOverall = value.betAmountOverall;
    user.balanceLeaderBoard = value.balanceLeaderBoard;
    user.monthlyLostBets = value.monthlyLostBets;
    user.monthlyLostPredictions = value.monthlyLostPredictions;
    user.monthlyWonBets = value.monthlyWonBets;
    user.monthlyWonPredictions = value.monthlyWonPredictions;
    user.overallLostBets = value.overallLostBets;
    user.overallLostPredictions = value.overallLostPredictions;
    user.overallWonPredictions = value.overallWonPredictions;
    user.overallWonBets = value.overallWonBets;
  }


}