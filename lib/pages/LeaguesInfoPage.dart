
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/JsonHelper.dart';
import 'package:flutter_app/models/constants/PageConstants.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:flutter_app/models/League.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/row/DialogProgressBarWithText.dart';
import 'package:http/http.dart';

import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../utils/SecureUtils.dart';
import '../widgets/row/SimpleLeagueRow.dart';


class LeaguesInfoPage extends StatefulWidget{//}WithName {


  final Map<int, League> leagues;

  @override
  LeaguesInfoPageState createState() => LeaguesInfoPageState();

  LeaguesInfoPage({
    Key? key,
    required this.leagues
  } ) : super(key: key);

}

class LeaguesInfoPageState extends State<LeaguesInfoPage>{

  late Map<int, League> leagues;

  @override
  void initState() {

    super.initState();

     leagues = widget.leagues;

  }

  @override
  Widget build(BuildContext context) {

    if (leagues.isEmpty){
      return const DialogProgressText(text: 'Loading...');
    }

    List<League> allLeagues =  leagues.values.toList();
    allLeagues.sort();

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

