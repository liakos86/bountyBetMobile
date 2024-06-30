
import 'dart:async';
import 'dart:convert';

import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:http/http.dart';

import '../models/Season.dart';
import '../models/Standing.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../models/LeagueWithData.dart';
import '../widgets/row/LeagueStandingRow.dart';


class LeagueStandingPage extends StatefulWidgetWithName {

  @override
  LeagueStandingPageState createState() => LeagueStandingPageState(leagueId, seasonId);

  // League league = League.defLeague();
  // Season season = Season.defSeason();

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
    // TODO: implement initState
    super.initState();

    getSeasonStandings(leagueId, seasonId).then((season) =>
        updateStateFor(season));

    Timer.periodic(const Duration(seconds: 120), (timer) {

      getSeasonStandings(leagueId, seasonId).then((season) =>
          updateStateFor(season));

    });

  }

  @override
  Widget build(BuildContext context) {

    if (season.id < 0){
      return Text('WAITING.......');
    }

    return

    Scaffold(
      appBar: AppBar(title: Text(season.leagueInfo.name)),
      body:
      Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(

            children: [

              CachedNetworkImage(
                imageUrl: season.leagueInfo.logo! ?? "",
                placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 64, height: 64,),
                errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 64, height: 64,),
                height: 32,
                width: 32,
              )

            ],

          ),
        ),

        Expanded(
        flex: 4,
        child:
        ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: season.standing.standingRows.length,
                    itemBuilder: (context, item) {
                      return _buildRow(season.standing.standingRows[item]);
                    })
        )
    ] ));

  }

  Widget _buildRow(StandingRow row) {

    return LeagueStandingRow(key: UniqueKey(), standing: row, );
  }

  Future<Season> getSeasonStandings(int leagueId, int seasonId) async {
    String getSeasonUrlFinal = UrlConstants.GET_SEASON_STANDINGS.replaceFirst("{1}", leagueId.toString()).replaceFirst("{2}", seasonId.toString());

    try {
      Response userResponse = await get(Uri.parse(getSeasonUrlFinal)).timeout(const Duration(seconds: 5));
      var responseDec = await jsonDecode(userResponse.body);
      return  Season.seasonFromJson(responseDec);
    } catch (e) {
      print(e);
      return Season.defSeason();
    }
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