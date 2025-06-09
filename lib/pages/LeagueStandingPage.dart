
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';

import '../models/Season.dart';
import '../models/constants/ColorConstants.dart';
import '../widgets/row/LeagueStandingRow.dart';


class LeagueStandingPage extends StatefulWidget{//}WithName {

  @override
  LeagueStandingPageState createState() => LeagueStandingPageState(leagueId, seasonId);



  final int leagueId;

  final int seasonId;

  LeagueStandingPage({
    Key? key,
    required this.leagueId,
    required this.seasonId,

  } ) : super(key: key);

}

class LeagueStandingPageState extends State<LeagueStandingPage>{

  // League league = League.defLeague();
  Season season = Season.defSeason();

  int leagueId =0;
  int seasonId =0;

  LeagueStandingPageState(leagueId, seasonId) {
    this.seasonId = seasonId;
    this.leagueId = leagueId;
  }

  @override
  void initState() {
    super.initState();

    HttpActionsClient.getSeasonStandings(leagueId, seasonId).then((season) =>
        updateStateFor(season));

    Timer.periodic(const Duration(seconds: 120), (timer) {

      HttpActionsClient.getSeasonStandings(leagueId, seasonId).then((season) =>
          updateStateFor(season));

    });

  }

  @override
  Widget build(BuildContext context) {

    if (season.id < 0){
      return const CircularProgressIndicator(color: Color(ColorConstants.my_green),);
    }

    return

    Scaffold(
      appBar: AppBar(title:



      Text(season.leagueInfo.name)),
      body:




      Column(
      children: [
        Expanded(
          flex: 1,
          child:
          Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                color:  Colors.black87,
                 // Dark background color
                borderRadius: BorderRadius.circular(12),
              ),

          child:

          const Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

            Expanded(
            flex: 5,
            child:
              Text('#', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(ColorConstants.my_green)),)),


            Expanded(
              flex: 1,
              child:
              Text('W-D-L', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(ColorConstants.my_green)),)),


              Expanded(
                  flex: 1,
                  child:
              Text('GF:GA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(ColorConstants.my_green)),)),

            Expanded(
              flex: 1,
              child:

              Text('Points', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(ColorConstants.my_green)),)),


            ],

          ),
        )),

        Expanded(
        flex: 9,
        child:
        ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: season.standing.standingRows.length,
                    itemBuilder: (context, item) {
                      return _buildRow(season.standing.standingRows[item]);
                    })
        )
    ]
              )


    );

  }

  Widget _buildRow(StandingRow row) {

    return LeagueStandingRow(key: UniqueKey(), standing: row, );
  }



  updateStateFor(seasonNew) {
    if (seasonNew == null){
      return;
    }

    Season.copyFields(seasonNew, season);

    setState(() {
      season;
    });

  }



}