import 'Standing.dart';

class Season{

  int ?id;
  int year_start;
  int year_end;
  int ?league_id;
  String ?slug;
  String ?name;

  Standing standing;

  Season({
    required this.year_start,
    required this.year_end,
    required this.standing
  });

}