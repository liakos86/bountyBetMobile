import 'dart:convert';

import '../pages/ParentPage.dart';
import 'constants/Constants.dart';

class Section{

  String name;
  int id;
  int sport_id;
  // String? slug;
  String? flag;

  Map<String, dynamic> ?name_translations;

  Section({ required this.id, required this.name, required this.sport_id, required this.flag});

  static Section fromJson(sectionJson) {

      Section section = Section(name: sectionJson['name'], id: sectionJson['id'], sport_id: sectionJson['sport_id'], flag: sectionJson['flag']);

      if (sectionJson['name_translations'] != null){
        section.name_translations = sectionJson['name_translations'];
      }

    return section;
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


}