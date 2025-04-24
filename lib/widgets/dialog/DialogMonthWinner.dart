import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/User.dart';
import '../../models/UserMonthlyBalance.dart';
import '../../models/constants/ColorConstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../row/LeaderBoardUserPlainRow.dart';


class DialogMonthWinner extends StatefulWidget {


  final List<User> users;

  final Function confirmWinnerCallback;

  DialogMonthWinner({Key ?key, required this.users, required this.confirmWinnerCallback}) : super(key: key);

    @override
  DialogMonthWinnerState createState() => DialogMonthWinnerState(users: users, confirmWinnerCallback: confirmWinnerCallback);
}

  class DialogMonthWinnerState extends State<DialogMonthWinner> with SingleTickerProviderStateMixin {

 
      ParticleOptions? particles;

      List<User> users;

      Function confirmWinnerCallback;

      DialogMonthWinnerState({
        required this.users,
        required this.confirmWinnerCallback
      });


  @override
  Widget build(BuildContext context) {

        particles =  ParticleOptions(
      image:  Image.asset('assets/images/money-bag-100.png'),
      baseColor:  Colors.amber,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 20,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );


        users.sort();

        User myUserInWinners = users.firstWhere((element) => element.mongoUserId == AppContext.user.mongoUserId, orElse: () => User.defUser(),);


        return

      AlertDialog(
          title:
          Text(
           (myUserInWinners.mongoUserId != Constants.defMongoId)?

           '🎉 🎉 🎉 ${AppLocalizations.of(context)!.congrats_text(myUserInWinners.balance.position , myUserInWinners.balance.balanceLeaderBoard)} 🎊 🎊 🎊'

            :
           '🎉 🎉 🎉 ${AppLocalizations.of(context)!.leaders_previous_month_text} 🎊 🎊 🎊',

            style: const TextStyle(fontSize: 16.0),
          ),

          insetPadding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 12.0),
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content:
          Builder(
              builder: (context) {
                return

                  // SizedBox(width: width,
                  //   child:



                    AnimatedBackground(
                      vsync: this,
                      behaviour: RandomParticleBehaviour(options: particles!),
                      child:

                      // SingleChildScrollView( // Make the scrollable area take the full available space
                      //     child:

                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                    Expanded(flex:6, child:
                          ListView.builder(
                              key: const PageStorageKey<String>(
                                  'leaderFinalPreviousMonth'),
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                              itemCount: users.length,
                              itemBuilder: (context, item) {
                                User user = users[item];
                                // return _buildUserRow((item+1).toString(), user, 'curr$item${user.mongoUserId}');
                                return _buildLeaderUserRowPlain(user, 'monthWinner$item${user.mongoUserId}');
                              })
                    ),



                    Expanded(flex:1, child:
                    SizedBox(width: double.infinity, height:80, child:
                          ElevatedButton(
                            onPressed: () {
                              // Handle button press
                              Navigator.pop(context);
                              confirmWinnerCallback.call(users.first.balance, false);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: const Color(ColorConstants.my_dark_grey),  // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Rounded radius
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // Button size
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.close,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          )
                    )
                    )

                        ]
                    )
                    // )
                // )

                );
              }
          )

      );
  }

  Widget _buildLeaderUserRowPlain(User user,  String s) {
    return LeaderBoardUserPlainRow(balance: user.balance, username: user.username);
    // return Text('hrllo');
  }





}


