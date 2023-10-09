
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';

import '../models/league.dart';
import '../widgets/SimpleLeagueRow.dart';


class LeaguesInfoPage extends StatefulWidgetWithName {

  final List<League> allLeagues;

  @override
  LeaguesInfoPageState createState() => LeaguesInfoPageState();

  LeaguesInfoPage({
    Key? key,
    required this.allLeagues,

  } ) : super(key: key);

}

class LeaguesInfoPageState extends State<LeaguesInfoPage>{

  List<League> allLeagues = <League>[];

  @override
  void initState() {
    allLeagues = widget.allLeagues;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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

  }

