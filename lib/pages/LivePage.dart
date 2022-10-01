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
import '../widgets/LiveMatchRow.dart';
import '../widgets/UpcomingMatchRow.dart';


class LivePage extends StatefulWidgetWithName {

 // Set liveMatches = new HashSet<MatchEvent>();

  var liveMatches = <MatchEvent>[];

  Function functionEvents = ()=>{};

  @override
  LivePageState createState() => LivePageState(liveMatches, functionEvents);

  LivePage(liveMatches, functionEvents) {
    this.liveMatches = liveMatches;
    this.functionEvents = functionEvents;
    setName('Live');
  }

}

class LivePageState extends State<LivePage>{

  @override
  void initState(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      getLive();
    });

    super.initState();
  }

  var liveList = <MatchEvent>[];

  Function functionEvents = ()=>{};

  LivePageState(liveMatches, functionEvents) {
    this.liveList = liveMatches;
    this.functionEvents = functionEvents;
  }

  @override
  Widget build(BuildContext context) {

    if (liveList.isEmpty){
      return Text('No games yet..');
    }

    return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: liveList.length,
                  itemBuilder: (context, item) {
                    return _buildRow(liveList[item]);
                  });

  }

  Widget _buildRow(MatchEvent gameWithOdds) {
    if (gameWithOdds.eventId==1212754){print("BUILDING${gameWithOdds.homeTeamScore?.current}");}
    return LiveMatchRow(key: UniqueKey(), gameWithOdds: gameWithOdds);
  }

  void getLive() async {
    var validData = <MatchEvent>[];

    try {

      List jsonLeaguesData = <String>[];
      try {
        Response leaguesResponse = await get(Uri.parse(UrlConstants.GET_LIVE))
            .timeout(const Duration(seconds: 4));
        jsonLeaguesData = jsonDecode(leaguesResponse.body) as List;
      } catch (e) {
        print(e);
        var events = <MatchEvent>[];
        Set<MatchEvent> eventsMock = MockUtils().mockEvents();
        for (MatchEvent event in eventsMock){
          if (event.status == "inprogress") {
            events.add(event);
          }
        }

        setState(() {
          liveList = events;
        });
        return;
      }

      for (var event in jsonLeaguesData) {
        MatchEvent liveEvent = JsonHelper.eventFromJson(event);
        validData.add(liveEvent);
      }

      setState(() {
        liveList = validData;
      });
    } catch (err) {
      print(err);
    }
  }

}