import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';

import '../models/UserPrediction.dart';
import '../models/league.dart';
import 'UpcomingMatchRow.dart';

class LeagueMatchesRow extends StatefulWidget {

  League league;

 List<UserPrediction> selectedOdds = <UserPrediction>[];

  Function(UserPrediction) callbackForOdds;

 // Function ?callbackForEvents;

  LeagueMatchesRow(
      {Key ?key, required this.league, required this.selectedOdds, required this.callbackForOdds})
      : super(key: key);

  @override
  LeagueMatchesRowState createState() =>
      LeagueMatchesRowState(league: league,
          selectedOdds: selectedOdds,
          callbackForOdds: callbackForOdds);
}

  class LeagueMatchesRowState extends State<LeagueMatchesRow>{

    League league;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function(UserPrediction) callbackForOdds;

    LeagueMatchesRowState({required this.league, required this.selectedOdds, required this.callbackForOdds});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Colors.transparent,
      collapsedIconColor: Colors.transparent,
      initiallyExpanded: true,
      //tilePadding: EdgeInsets.all(2),
      backgroundColor: Colors.blue[50],
      subtitle: Text(league.section!.name, style: TextStyle(color: Colors.black, fontSize: 10),),
      leading: Image.network(
        league.logo ?? "https://tipsscore.com/resb/no-league.png",
        height: 32,
        width: 32,
      ),
      title: Text(league.name,
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
      children: league.getEvents().map((item)=> _buildSelectedOddRow(item)).toList()
    );
  }

  Widget _buildSelectedOddRow(MatchEvent event) {
    if (event.status == MatchStatus.IN_PROGRESS || event.status == MatchStatus.FINISHED
        || event.status == MatchStatus.POSTPONED || event.status == MatchStatus.CANCELLED) {
      return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
    }

    return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

}