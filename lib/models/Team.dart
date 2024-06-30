import 'dart:convert';
import 'dart:ui';

import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/pages/ParentPage.dart';

import 'constants/JsonConstants.dart';

class Team{

  int id;

  int ?sport_id;

  int ?category_id;

  int ?venue_id;

  int ?manager_id;

  String ?slug;

  String name;

  String ?name_short;

  String ?name_full;

  String logo;

  Map<String, dynamic> ?name_translations;

  Team(this.id, this.name, this.logo);

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

  static Team fromJson(Map<String, dynamic> jsonValues){
    Team hTeam = Team(jsonValues[JsonConstants.id], jsonValues["name"], jsonValues["logo"]);

    if (jsonValues['name_translations'] != null){
      hTeam.name_translations = jsonValues['name_translations'];
    }

    return hTeam;
  }

}