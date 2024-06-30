import 'StandingRow.dart';
import 'Team.dart';
import 'constants/JsonConstants.dart';
import 'League.dart';

class Standing{


  List<StandingRow> standingRows = <StandingRow>[];

  Standing({required this.standingRows});

  Standing.defStanding();

  static Standing standingFromJson(standing) {
    List<StandingRow> rows = <StandingRow>[];

    //var standing = seasonJson['standing'];

    var stRows = standing['standings_rows'];
    for (var stRow in stRows){

      print('checking row ' + stRow['position'].toString());

      var teamJson = stRow['team'];
      Team hTeam = Team(teamJson[JsonConstants.id], teamJson["name"], teamJson["logo"]);
      if (teamJson['name_translations'] != null){
        hTeam.name_translations = teamJson['name_translations'];
      }

      StandingRow row = StandingRow(team: hTeam);
      row.away_points = int.parse( stRow['away_points']);
      row.home_points = int.parse(stRow['home_points']);
      row.position = stRow['position'];
      rows.add(row);
    }


    rows.sort();


    return Standing(standingRows: rows);

  }

}