

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Standing.dart';
import 'package:flutter_app/models/UserAward.dart';
import '../../models/League.dart';
import '../../models/Season.dart';
import '../../models/User.dart';
import '../../models/constants/Constants.dart';
import '../../models/LeagueWithData.dart';
import '../../pages/LeagueStandingPage.dart';

class LeaderBoardAwardRow extends StatefulWidget {


  final UserAward award;

  final String username;

  LeaderBoardAwardRow({Key ?key, required this.award, required this.username}) : super(key: key);

  @override
  LeaderBoardAwardRowState createState() => LeaderBoardAwardRowState(award: award, username: username);
}

class LeaderBoardAwardRowState extends State<LeaderBoardAwardRow> {

  UserAward award;

  String username;

  LeaderBoardAwardRowState({
    required this.award,
    required this.username
  });


  @override
  Widget build(BuildContext context) {

    var awardMonth = award.awardMonth;
    var awardYear = award.awardYear;

    return

      GestureDetector(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Text('what?')),
          );

    },
    child:

       SizedBox(
         height: 76,
    child:
          Row(//top father

              //mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                 Expanded(//first column
                    flex: 2,
                    child:

                    // Column(
                    //
                    // children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Padding(
                            padding: const EdgeInsets.all(4), child:

                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(

                                child: Text( '$awardMonth/$awardYear', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                                  // child: CachedNetworkImage(
                                  //   imageUrl: user.username ?? '',
                                  //   placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                                  //   errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                                  //   height: 32,
                                  //   width: 32,
                                  // )
                              ),
                              WidgetSpan(child: SizedBox(width: 16)),

                            ],
                          ),
                        )

                        ),
                        ),

                    // ]
                // )
       ),

                Expanded(//first column
                  flex: 2,
                  child:

                  // Column(
                  //
                  // children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Padding(
                        padding: const EdgeInsets.all(4), child:

                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(

                              child: Text( '$username with ${award.winningBalance}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            // child: CachedNetworkImage(
                            //   imageUrl: user.username ?? '',
                            //   placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                            //   errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
                            //   height: 32,
                            //   width: 32,
                            // )
                          ),
                          WidgetSpan(child: SizedBox(width: 16)),

                        ],
                      ),
                    )

                    ),
                  ),

                  // ]
                  // )
                ),
      //), // FIRST COLUMN END

              ]
          )
      )
      );
      // )
      // );
  }

}


