import 'dart:async';
import 'dart:collection';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/models/constants/UrlConstants.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:http/http.dart';

import '../enums/BetPredictionType.dart';
import '../helper/JsonHelper.dart';
import '../models/constants/MatchConstants.dart';
import '../utils/MockUtils.dart';
import '../models/UserPrediction.dart';
import '../models/league.dart';
import '../models/match_event.dart';
import '../models/match_odds.dart';
import '../widgets/LeagueExpandableTile.dart';
import '../widgets/LeagueStandingRow.dart';
import '../widgets/LiveMatchRow.dart';
import '../widgets/SimpleLeagueRow.dart';
import '../widgets/UpcomingMatchRow.dart';


class LeagueStandingPage extends StatefulWidgetWithName {

  @override
  LeagueStandingPageState createState() => LeagueStandingPageState(league);

  League league = League.defLeague();

  LeagueStandingPage(League league) {
    this.league = league;
    setName(league.name );
  }

}

class LeagueStandingPageState extends State<LeagueStandingPage>{

  League league = League.defLeague();


  LeagueStandingPageState(league) {
    this.league = league;
  }

  @override
  Widget build(BuildContext context) {

    return

      Column(
      children: [

        Expanded(
          flex: 1,
          child: Text('efef'),


      ),

      Expanded(
      flex: 4,
      child:
      ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: league.seasons.first.standing.standingRows.length,
                  itemBuilder: (context, item) {
                    return _buildRow(league.seasons.first.standing.standingRows[item]);
                  })
      )
    ] );

  }

  Widget _buildRow(StandingRow row) {
    return LeagueStandingRow(key: UniqueKey(), standing: row);
  }

}