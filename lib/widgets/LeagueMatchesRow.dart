import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';

import '../models/UserPrediction.dart';
import '../models/UserBet.dart';
import '../models/league.dart';
import '../utils/MockUtils.dart';
import 'UpcomingMatchRow.dart';
import 'UserBetPredictionRow.dart';

class LeagueMatchesRow extends StatelessWidget{

  League league;

  LeagueMatchesRow({Key ?key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.all(8),
      backgroundColor: Colors.grey[300],
      subtitle: Text(league.name),
      leading: Image.network(
        league.logo ?? "https://tipsscore.com/resb/team/southampton.png",
        height: 36,
        width: 36,
      ),
      title: Text(league.name,
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
      children: league.getEvents().map((item)=> _buildSelectedOddRow(item)).toList()
    );
  }

  Widget _buildSelectedOddRow(MatchEvent event) {
    if (event.status == "inprogress") {
      return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
    }

    return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event);
  }

}