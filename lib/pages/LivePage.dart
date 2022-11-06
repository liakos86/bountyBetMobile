import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';

import '../models/league.dart';
import '../widgets/LeagueExpandableTile.dart';


class LivePage extends StatefulWidgetWithName {

  @override
  LivePageState createState() => LivePageState(liveMatchesPerLeague, functionReloadLiveLeagues);

  List<League> liveMatchesPerLeague = <League>[];

  Function functionReloadLiveLeagues = ()=>{};

  LivePage(List<League> _liveMatchesPerLeague, getLiveEventsCallBack) {
    this.liveMatchesPerLeague = _liveMatchesPerLeague;
    this.functionReloadLiveLeagues = getLiveEventsCallBack;
    setName('Live');
  }

}

class LivePageState extends State<LivePage>{

  @override
  void initState(){
    super.initState();
  }

  List<League> liveMatchesPerLeague = <League>[];

  Function functionReloadLiveLeagues = ()=>{};

  LivePageState(liveMatches, functionEvents) {
    this.liveMatchesPerLeague = liveMatches;
    this.functionReloadLiveLeagues = functionEvents;
  }

  @override
  Widget build(BuildContext context) {

    Timer.periodic(Duration(seconds: 5), (timer) {
      updateLiveFromParent();
    });


    // if (liveMatchesPerLeague.isEmpty){
    //   return Text('No games yet..');
    // }

    return ListView.builder(

                  itemCount: liveMatchesPerLeague.length,
                  itemBuilder: (context, item) {
                    return _buildRow(liveMatchesPerLeague[item]);
                  });

  }

  Widget _buildRow(League league) {
    return LeagueMatchesRow(key: UniqueKey(), league: league, selectedOdds: [], callbackForOdds: (a)=>{},);
  }

  void updateLiveFromParent() {

    List<League> leagues = functionReloadLiveLeagues.call();

    if (this.mounted && leagues.isNotEmpty) {
      setState(() {
        this.liveMatchesPerLeague = leagues;
      });
    }

  }

}