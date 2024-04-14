
import 'dart:async';
import 'dart:io';

import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';

import '../models/constants/Constants.dart';
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

    Image leagueImg = Image(
      image: CachedNetworkImageProvider(league.logo!),
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

  }

