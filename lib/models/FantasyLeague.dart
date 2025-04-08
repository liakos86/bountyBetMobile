import 'dart:convert';

import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/match_event.dart';

// import 'Season.dart';
import '../helper/SharedPrefs.dart';
import '../pages/ParentPage.dart';
import 'Section.dart';
import 'constants/JsonConstants.dart';

class FantasyLeague implements Comparable<FantasyLeague>{

  FantasyLeague({
    required this.name,
  });

  FantasyLeague.defConst();


  String name = Constants.empty;

  int fantasy_league_id = -1;

  static Future<FantasyLeague> fromJson(league) async{

    return FantasyLeague.defConst();
  }

  @override
  int compareTo(FantasyLeague other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }


}

