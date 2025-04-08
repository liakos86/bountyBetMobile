import 'constants/JsonConstants.dart';

class Player{

  int id;

  int sport_id;

  //String slug;

  String name;

  //Map <String, String> name_translations = new HashMap<>();

  String name_short;

  bool has_photo;

  String photo;

  String position;

  String position_name;

  Player({
    required this.id,
    required this.sport_id,
    required this.name,
    required this.name_short,
    required this.position,
    required this.has_photo,
    required this.photo,
    required this.position_name

  });

  static Player? fromJson(model) {
    if (model == null){
      return null;
    }

    return Player(id: (model[JsonConstants.id]), sport_id:(model['sport_id']), name: model[JsonConstants.name], name_short: model['name_short'] ?? 'n/a', position: model['position'] ?? 'n/a', has_photo: (model['has_photo'] == 'true' ? true : false), photo: model['photo'], position_name: model['position_name'] ?? 'n/a');

  }

}