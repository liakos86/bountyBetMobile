import 'dart:convert';

import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/pages/ParentPage.dart';

import 'constants/JsonConstants.dart';

class Team{

  int id;

  int ?sport_id;

  int ?category_id;

  int ?venue_id;

  int ?manager_id;

  // String ?slug;

  String name;

  String ?name_short;

  String ?name_full;

  String logo = Constants.assetNoTeamImage;

  Map<String, dynamic> ?name_translations;

  Team(this.id, this.name);

  String getLocalizedName(){
    if (name_translations == null){
      return name;
    }

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