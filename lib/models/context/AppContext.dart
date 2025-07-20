import 'dart:collection';

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
  static final Map<String, List<LeagueWithData>> eventsPerDayMap = HashMap<String, List<LeagueWithData>>();
  static final List<LeagueWithData> liveLeagues = [];

  /*
   * The logged user.
   */
  static User user = User.defUser();

  AppContext();


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

}