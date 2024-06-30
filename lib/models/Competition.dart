import 'LeagueWithData.dart';

class Competition{

  String competitionId;

  String competitionName;

  String competitionLogo;

  List<LeagueWithData> leagues = <LeagueWithData>[];

  Competition(this.competitionId, this.competitionName, this.competitionLogo);

}