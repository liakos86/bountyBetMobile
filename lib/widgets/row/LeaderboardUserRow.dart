import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../LeaderboardUserAlertDialog.dart';
import '../../models/User.dart';

class LeaderboardUserRow extends StatefulWidget {

  final User user;

  // final ParticleOptions particles;


  LeaderboardUserRow({Key ?key, required this.user}) : super(key: key);

  @override
  LeaderboardRowState createState() => LeaderboardRowState(user: user);
}

class LeaderboardRowState extends State<LeaderboardUserRow>  with SingleTickerProviderStateMixin{

  User user;

  // ParticleOptions particles;


  LeaderboardRowState({
    required this.user,
    // required this.particles
  });

  @override
  Widget build(BuildContext context) {


    // Defining Particles for animation.
    ParticleOptions particles =  ParticleOptions(
      image:  Image.asset('assets/images/1.png'),
      baseColor:  Colors.cyan,
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

          height: 100,
          color: Colors.white,
          child:

              GestureDetector(

                onTap: () async =>{
                  showDialog(context: context, builder: (context) =>

                    AlertDialog(

                        insetPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.all(2.0),
                        buttonPadding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        elevation: 20,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(
                            Radius.circular(3.0))),
                        content: Builder(
                            builder: (context) {
                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                              var height = MediaQuery.of(context).size.height * (2/3);
                              var width = MediaQuery.of(context).size.width * (4/5);

                              return
                                SizedBox(
                                  width: width,
                                  height: height,
                                  child :
                                  LeaderboardUserAlertDialog(user:user)
                              );

                            })

                    ))
                }
                  ,

              child:


    Card(
      color: user.mongoUserId == ParentPageState.user.mongoUserId ? Colors.greenAccent : Colors.cyan[50],
      child:
      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child:
      Padding(
        padding: EdgeInsets.all(
           8),
        child:
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child:

          //CircularProgressIndicator(value: 0.5, color: Colors.green, backgroundColor: Colors.red[100], semanticsLabel: "50%"),
          Container(
            // height: 50.0,
            // width: 50.0,
            color: Colors.transparent,
            child:

              Row(
                children: [

                  Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: Icon(Icons.person_2_rounded, size:48, color: Colors.redAccent,))),// Image.asset(Constants.assetNoTeamImage))
                  Expanded(flex: 2, child: Text(user.username + 'faaaaaaaaaaaaaaaaaaaaaaaaaaaaaaafffffffffffffffffffffffffffffffffffffffffff', maxLines: 2, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)),// Image.asset(Constants.assetNoTeamImage))
                  Expanded(flex: 2, child:  Column(mainAxisSize: MainAxisSize.min, children:[
                    Text('${user.balance.toInt()} ${AppLocalizations.of(context)!.points}', maxLines: 1, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    Text('${user.monthlyWonBets}/${user.monthlyWonBets+user.monthlyLostBets} ${AppLocalizations.of(context)!.won}', maxLines: 1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                  ])
                  ),// Image.asset(Constants.assetNoTeamImage))


                ],

              )




            ),

        ),
      ),
      )) ));
  }
}


