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
import '../widgets/LeagueMatchesRow.dart';
import '../widgets/LiveMatchRow.dart';
import '../widgets/UpcomingMatchRow.dart';


class LivePage2 extends StatefulWidgetWithName {

  @override
  LivePageState2 createState() => LivePageState2();

  LivePage2() {
    setName('Live');
  }

}

class LivePageState2 extends State<LivePage2>{

  @override
  void initState(){
    print('SETTING');
    Timer.periodic(Duration(seconds: 5), (timer) {
      getLive();
    });

    super.initState();
  }

  List<League> liveMatchesPerLeague = <League>[];
  
  LivePageState() {  }

  @override
  Widget build(BuildContext context) {

    if (liveMatchesPerLeague.isEmpty){
      return Text('No games yet..');
    }

    return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: liveMatchesPerLeague.length,
                  itemBuilder: (context, item) {
                    return _buildRow(liveMatchesPerLeague[item]);
                  });

  }

  Widget _buildRow(League league) {
    return LeagueMatchesRow(key: UniqueKey(), league: league);
  }

  void getLive() async {
    var validData = <League>[];

    try {

      List jsonLeaguesData = [];
      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LIVE))
            .timeout(const Duration(seconds: 4));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print(e);
        List<League> leagues = MockUtils().mockLeagues(true);
        setState(() {
          liveMatchesPerLeague = leagues;
        });
        return;
      }

      for (var league in jsonLeaguesData) {
        League liveLeague = JsonHelper.leagueFromJson(league);
        validData.add(liveLeague);
      }

      setState(() {
        liveMatchesPerLeague = validData;
      });
    } catch (err) {
      print(err);
    }
  }

}