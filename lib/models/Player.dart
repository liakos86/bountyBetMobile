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

}