import 'dart:convert';

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

      // print('checking row ' + stRow['position'].toString());

      var teamJson = stRow['team'];
      Team hTeam = Team.fromJson(teamJson);


      StandingRow row = StandingRow(team: hTeam);
      row.position = stRow['position'];


      Map<String, dynamic> fields = stRow['fields'];


      row.draws_total = int.parse(fields['draws_total']);
      row.wins_total = int.parse(fields['wins_total']);
      row.losses_total = int.parse(fields['losses_total']);
      row.goals_total = (fields['goals_total']);
      row.points = int.parse(fields['points_total']);
      rows.add(row);
    }


    rows.sort();


    return Standing(standingRows: rows);

  }

}