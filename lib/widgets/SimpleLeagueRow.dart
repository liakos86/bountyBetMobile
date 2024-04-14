

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/constants/Constants.dart';
import '../models/league.dart';
import '../pages/LeagueStandingPage.dart';

class SimpleLeagueRow extends StatefulWidget {

  final League league;

  final ParticleOptions particles;

  SimpleLeagueRow({Key ?key, required this.league, required this.particles}) : super(key: key);

  @override
  SimpleLeagueRowState createState() => SimpleLeagueRowState(league: league, particles: particles);
}

class SimpleLeagueRowState extends State<SimpleLeagueRow> with SingleTickerProviderStateMixin {

  League league;

  ParticleOptions particles;

  SimpleLeagueRowState({
    required this.league,
    required this.particles
  });


  @override
  Widget build(BuildContext context) {

    return

      Container(height: 100,
          child:
      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
    child:


      GestureDetector(
        onTap: () {

          if (league.seasons.isEmpty){
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeagueStandingPage(league)),
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
                            padding: const EdgeInsets.all(6), child:

                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                  child: CachedNetworkImage(
                                    imageUrl: league.logo!,
                                    placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 48, height: 48,),
                                    errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 48, height: 48,),
                                    height: 48,
                                    width: 48,
                                  )
                              ),
                              const WidgetSpan(child: SizedBox(width: 30)),

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
                          Row(
                          children:[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(league.name + league.league_id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                          ),
                         ] ),

                          Row(
                              children:[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  Text(league.section?.name ?? 'Section null',
                                      style: TextStyle(
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


