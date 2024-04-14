import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/User.dart';

class LeaderboardUserRowNew extends StatefulWidget {

  final User user;

  final int position;

  LeaderboardUserRowNew({Key ?key, required this.user, required this.position}) : super(key: key);

  @override
  LeaderboardRowStateNew createState() => LeaderboardRowStateNew(user: user, position: position);
}

class LeaderboardRowStateNew extends State<LeaderboardUserRowNew>  with SingleTickerProviderStateMixin{

  User user;

  int position;

  LeaderboardRowStateNew({
    required this.user,
    required this.position
  });

  @override
  Widget build(BuildContext context) {

    // Defining Particles for animation.
    ParticleOptions particles =  ParticleOptions(
      image: position < 4 ? Image.asset('assets/images/$position.png') : null,
      baseColor: Colors.cyan,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.3,
      particleCount: 10,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );


    return

      Container(
          height: 120,
          color: Colors.white,
          child:

    Card(
      color: Colors.white,
      child:
      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child:
      Padding(
        padding: EdgeInsets.only(
            top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
        child:
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child:

              Column(

                children: [

    Expanded( //first column
    flex: 4,
    child:

         Row(
            children : [
           Expanded( //first column
           flex: 2,
           child:
            Stack(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.green, backgroundColor: Colors.red[100],
                    value: 0.4,
                  ),
                ),
                const Center(child: Text("40%")),
              ],
            )
        ),

              Expanded( //first column
                  flex: 8,
                  child:
                  Text(user.username)
              )


        ],

          )),

      Expanded( //first column
        flex: 2,
        child:

        //  children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 20,
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),

                    value: user.monthlyWonBets+user.monthlyLostBets == 0 ? 0 : user.monthlyWonBets/(user.monthlyWonBets+user.monthlyLostBets),
                    backgroundColor: Colors.red[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ),
                Align(child:  Text( (' BetSlips Month: ${user.monthlyWonBets}/${user.monthlyWonBets+user.monthlyLostBets} '
                    'Overall: ${user.overallWonBets}/${user.overallWonBets+user.overallLostBets}'),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),), alignment: Alignment.center,),
              ],
            )),

          Expanded( //first column
            flex: 2,
            child:
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 20,
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    value: (user.monthlyWonPredictions+user.monthlyLostPredictions == 0 ? 0 : user.monthlyWonPredictions/(user.monthlyWonPredictions+user.monthlyLostPredictions)),
                    backgroundColor: Colors.red[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ),
                Align(child:  Text( ('Predictions Month: ${user.monthlyWonPredictions}/${user.monthlyWonPredictions+user.monthlyLostPredictions} '
                    'Overall: ${user.overallWonPredictions}/${user.overallWonPredictions+user.overallLostPredictions}'),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),), alignment: Alignment.center,),
              ],
            )),
          ],
        ),
      ),
      )) ));
  }
}


