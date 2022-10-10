import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';

import '../models/league.dart';
import 'UpcomingMatchRow.dart';

class LeagueMatchesRow extends StatelessWidget{

  League league;

  LeagueMatchesRow({Key ?key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.all(8),
      backgroundColor: Colors.grey[300],
      subtitle: Text(league.section!.name),
      leading: Image.network(
        league.logo ?? "https://tipsscore.com/resb/no-league.png",
        height: 36,
        width: 36,
      ),
      title: Text(league.name,
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      children: league.getEvents().map((item)=> _buildSelectedOddRow(item)).toList()
    );
  }

  Widget _buildSelectedOddRow(MatchEvent event) {
    if (event.status == "inprogress" || event.status == "finished") {
      return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
    }

    return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event);
  }

}