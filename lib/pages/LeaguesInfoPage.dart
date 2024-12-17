
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
import 'package:http/http.dart';

import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../utils/SecureUtils.dart';
import '../widgets/row/SimpleLeagueRow.dart';


class LeaguesInfoPage extends StatefulWidgetWithName {

  @override
  LeaguesInfoPageState createState() => LeaguesInfoPageState();

  LeaguesInfoPage({
    Key? key,
  } ) : super(key: key);

}

class LeaguesInfoPageState extends State<LeaguesInfoPage>{

  final List<League> allLeagues = <League>[];

  @override
  void initState() {

    super.initState();

     HttpActionsClient.getStandingsWithoutTablesAsync().then((leaguesList) =>
        updateLeagues(leaguesList));

    Timer.periodic(const Duration(seconds: 20), (timer) {

      if (!this.mounted || ! (ParentPageState.selectedPageIndex == PageConstants.INDEX_PAGE_LEAGUE_INFO)){
        return;
      }

      HttpActionsClient.getStandingsWithoutTablesAsync().then((leaguesList) =>
          updateLeagues(leaguesList));
    });

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

    Image leagueImg = Image(
      image: CachedNetworkImageProvider(league.logo ?? ''),
        height: 16,
        width: 16,
      errorBuilder:
          ( context,  exception,  stackTrace) {
        if (exception is HttpException ) {
          return Image.asset(Constants.assetNoLeagueImage , width: 16, height: 16,);
        } else {
          return Image.asset(Constants.assetNoLeagueImage, width: 16, height: 16,);
        }
      },
    );

    // Defining Particles for animation.
    ParticleOptions particles = ParticleOptions(
      image: leagueImg,
      baseColor: Colors.cyan,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 5,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 50.0,
      spawnMinSpeed: 20,
      spawnMinRadius: 7.0,
    );

    return SimpleLeagueRow(key: UniqueKey(), league: league, particles: particles);
  }



  updateLeagues(List<League> leaguesList) {
    if ( leaguesList.isEmpty){
      return;
    }

    leaguesList.sort();
    allLeagues.clear();

    setState(() {
    allLeagues.addAll(leaguesList);

    });

  }

  }

