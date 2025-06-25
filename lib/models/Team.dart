import 'dart:convert';

import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/pages/ParentPage.dart';

import 'constants/JsonConstants.dart';

class Team{

  Team.defTeam();

  int id = 0;

  int ?sport_id;

  int ?category_id;

  int ?venue_id;

  int ?manager_id;

  // String ?slug;

  String name = 'team';

  String ?name_short;

  String ?name_full;

  String logo = Constants.assetNoTeamImage;

  Map<String, dynamic> ?name_translations;

  Team(this.id, this.name);


  String getLocalizedName() {
    if (name_translations == null || locale == null) return name;

    var candidates = locale!.toLowerCase().split(Constants.underscore);
    for (String candidate in candidates) {
      final raw = name_translations?[candidate];
      if (raw != null) {
        try {
          // Convert string (mis-decoded UTF-8) to bytes
          final bytes = raw.codeUnits;
          // Properly decode as UTF-8
          return utf8.decode(bytes);
        } catch (_) {
          return raw; // fallback
        }
      }
    }

    return name;
  }


  // String getLocalizedName(){
  //   if (name_translations == null){
  //     return name;
  //   }
  //
  //   if (locale == null){
  //     return name;
  //   }
  //
  //
  //   var candidates = locale?.toLowerCase().split(Constants.underscore);
  //   for (String candidate in candidates!){
  //     if (name_translations?[candidate] != null){
  //
  //       var utf8Text = name_translations?[candidate].runes.toList();
  //       return utf8.decode(utf8Text);
  //     }
  //   }
  //
  //   return name;
  // }




  static Team fromJson(Map<String, dynamic> jsonValues){
    Team hTeam = Team(jsonValues[JsonConstants.id], jsonValues["name"]);

    if (jsonValues["logo"] != null){
     hTeam.logo = jsonValues["logo"];
    }

    if (jsonValues['name_translations'] != null){
      hTeam.name_translations = jsonValues['name_translations'];
    }

    if (jsonValues['sport_id'] != null){
      hTeam.sport_id = jsonValues['sport_id'];
    }

    return hTeam;
  }

}