import 'dart:async';
import 'dart:collection';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../widgets/LiveMatchRow.dart';
import '../widgets/SimpleLeagueRow.dart';
import '../widgets/UpcomingMatchRow.dart';


class LeaguesInfoPage extends StatefulWidgetWithName {

  @override
  LeaguesInfoPageState createState() => LeaguesInfoPageState(allLeaguesFunction);

  Function allLeaguesFunction = ()=>{};

  LeaguesInfoPage(allLeaguesFunction) {
    this.allLeaguesFunction = allLeaguesFunction;
    setName('Leagues Information');
  }

}

class LeaguesInfoPageState extends State<LeaguesInfoPage>{

  List<League> allLeagues = <League>[];

  Function leaguesFunction = ()=>{};

  LeaguesInfoPageState(leagues) {
    this.leaguesFunction = leagues;
  }

  @override
  Widget build(BuildContext context) {

    Timer.periodic(Duration(seconds: 5), (timer) {
      updateLeaguesFromParent();
    });

    if (allLeagues.isEmpty){
      return Text('Loading..');
    }

    return
      ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: allLeagues.length,
      itemBuilder: (context, item) {
        return _buildRow(allLeagues[item]);
      });
  }

  Widget _buildRow(League league) {
    return SimpleLeagueRow(key: UniqueKey(), league: league);
  }

  void updateLeaguesFromParent() {
    List<League> leagues = leaguesFunction.call();
    if (leagues.isNotEmpty){

      if (!mounted){
        return;
      }
      setState(() {
        allLeagues = leagues;
      });
    }
  }

}