

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Standing.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import '../../models/League.dart';
import '../../models/Season.dart';
import '../../models/constants/Constants.dart';
import '../../models/LeagueWithData.dart';
import '../../pages/LeagueStandingPage.dart';

class SimpleLeagueRow extends StatefulWidget {


  // final League league;
  final League league;

  final ParticleOptions particles;

  SimpleLeagueRow({Key ?key, required this.league, required this.particles}) : super(key: key);

  @override
  SimpleLeagueRowState createState() => SimpleLeagueRowState(league: league, particles: particles);
}

class SimpleLeagueRowState extends State<SimpleLeagueRow> with SingleTickerProviderStateMixin {

  League league;
  // Season season;

  ParticleOptions particles;

  SimpleLeagueRowState({
    required this.league,
    required this.particles
  });


  @override
  Widget build(BuildContext context) {

    return

      SizedBox(height: 64,
          child:
      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child:

      GestureDetector(
        onTap: () {

          if (league.seasonIds.isEmpty){
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeagueStandingPage(leagueId: league.league_id, seasonId: league.seasonIds.first)),
          );

    },
    child:
      DecoratedBox(

          decoration: const BoxDecoration(color: Colors.transparent ),
          child:

          Row(//top father

              mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                Expanded(//first column
                    flex: 2,
                    child:

                    Column(

                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Padding(
                            padding: const EdgeInsets.all(4), child:

                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                  child: CachedNetworkImage(
                                    imageUrl: league.logo ?? '',
                                    placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                                    errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                                    height: 32,
                                    width: 32,
                                  )
                              ),
                              const WidgetSpan(child: SizedBox(width: 16)),

                            ],
                          ),
                        )

                        ),
                        ),

                    ]
                )),
      //), // FIRST COLUMN END

                Expanded(//first column
                    flex: 10,
                    child:

                    Column(

                        children: [
                          // Row(
                          // children:[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(league.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                          ),
                         // ]
                         //  ),

                          Row(
                              children:[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  Text(AppContext.allSectionsMap[league.section_id].getLocalizedName() ?? 'Section null',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black)),
                                ),
                              ] )
                        ]
                    )),

              ])//parent column end

      ))
      ));
  }

}


