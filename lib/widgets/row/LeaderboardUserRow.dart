import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/User.dart';

class LeaderboardUserRow extends StatefulWidget {

  final User user;

  final ParticleOptions particles;


  LeaderboardUserRow({Key ?key, required this.user, required this.particles}) : super(key: key);

  @override
  LeaderboardRowState createState() => LeaderboardRowState(user: user, particles: particles);
}

class LeaderboardRowState extends State<LeaderboardUserRow>  with SingleTickerProviderStateMixin{

  User user;

  ParticleOptions particles;


  LeaderboardRowState({
    required this.user,
    required this.particles
  });

  @override
  Widget build(BuildContext context) {

    return

      Container(height: 150,
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
            top: 16.0, left: 6.0, right: 6.0, bottom: 6.0),
        child:
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child:
          ExpansionTile(
          initiallyExpanded: true,

          backgroundColor: Colors.transparent,

          leading:
          //CircularProgressIndicator(value: 0.5, color: Colors.green, backgroundColor: Colors.red[100], semanticsLabel: "50%"),
          Container(
            height: 50.0,
            width: 50.0,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: new CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.green, backgroundColor: Colors.red[100],
                      value: 0.4,
                    ),
                  ),
                ),
                Center(child: Text("40%")),
              ],
            ),
          ),


          title: Text(user.username),
          children: <Widget>[
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
            ),
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
            ),
          ],
        ),
      ),
      )) ));
  }
}


