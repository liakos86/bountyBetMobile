import 'dart:convert';

import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

// import 'Season.dart';
import '../pages/ParentPage.dart';
import 'Section.dart';
import 'constants/JsonConstants.dart';

class League implements Comparable<League>{

  League({
    required this.name,
    required this.league_id,
    required this.section_id,
    required this.has_logo,
    required this.priority
  });

  League.defConst();

  Map<String, dynamic> ?name_translations;

  int section_id = -1;

  bool has_logo = false;

  String name = Constants.empty;

  int league_id = -1;

  String? logo;

  List<int> seasonIds = <int>[];
  //
  // List<MatchEvent> liveEvents = <MatchEvent>[];

  int priority = 0;

  static League fromJson(league) {
    League li = League(
        name: league[JsonConstants.name],
        league_id: league[JsonConstants.id],
        section_id: league[JsonConstants.sectionId],
        has_logo: league[JsonConstants.hasLogo],
        priority: league[JsonConstants.priority]
    );

    li.logo = league[JsonConstants.logo];

    List<int> leagueSeasonIds = <int>[];
    var seasonsJson = league['seasonIds'];
    if (seasonsJson != null ){
      for (int seasonJson in seasonsJson) {
        leagueSeasonIds.add(seasonJson);
      }
    }

    li.seasonIds = leagueSeasonIds;

    if (league['name_translations'] != null){
      li.name_translations = league['name_translations'];
    }

    return li;
  }

  String getLocalizedName(){
    if (name_translations == null){
      return name;
    }

    if (locale == null){
      return name;
    }

    //String? lang = locale?.languageCode;
    if (locale == null){
      return name;
    }

    var candidates = locale?.toLowerCase().split(Constants.underscore);
    for (String candidate in candidates!){
      if (name_translations?[candidate] != null){

        var utf8Text = name_translations?[candidate].runes.toList();
        return utf8.decode(utf8Text);
      }
    }

    return name;
  }



  @override
  int get hashCode => league_id * 37;

  @override
  int compareTo(League other) {
    if (this.priority > other.priority){
      return -1;
    }

    if (this.priority < other.priority){
      return 1;
    }

    if (this.name.compareTo(other.name) < 0){
      return -1;
    }

    if (this.name.compareTo(other.name) > 0){
      return 1;
    }

    return 0;
  }
}

