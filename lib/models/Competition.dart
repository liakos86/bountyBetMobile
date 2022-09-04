import 'league.dart';

class Competition{

  String competitionId;

  String competitionName;

  String competitionLogo;

  List<League> leagues = <League>[];

  Competition(this.competitionId, this.competitionName, this.competitionLogo);

}