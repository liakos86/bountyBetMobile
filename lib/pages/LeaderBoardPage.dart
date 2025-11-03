import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/User.dart';
import '../models/UserMonthlyBalance.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../widgets/row/GlobalLeaderBoardRow.dart';
import 'LivePage.dart';


class LeaderBoardPage extends StatefulWidget{//}WithName {

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  // Map<String, List<User>> leaders = {};
  List<User> leaders = <User>[];

  List<UserMonthlyBalance> balances = <UserMonthlyBalance>[];

  // late TabController _tabController;

  bool isMinimized = false;

  // bool alertDialogOpen = false;
  //
  bool isPreviousMonthWinner = false;

  // UserMonthlyBalance iAmMonthWinner = UserMonthlyBalance.defBalance();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    // _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is minimized or moved to the background
      setState(() {
        isMinimized = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      // App is active again
      setState(() {
        isMinimized = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    leaders = <User>[];
    // leaders['1'] = <User>[];
    // leaders['2'] = <User>[];

    // _tabController = TabController(length: 1, vsync: this);
    // _tabController.addListener(() {
    //   setState(() {});
    // });

    WidgetsBinding.instance.addObserver(this); // Add observer


   getLeaderBoard();
   Timer.periodic(const Duration(seconds: 60), (timer) {(
       getLeaderBoard()
   );
   } );

  }

  @override
  Widget build(BuildContext context) {


    String infoMsg = AppLocalizations.of(context)!.leaderboard_info
        + (

        AppContext.user.mongoUserId != Constants.defMongoId ?

    (AppLocalizations.of(context)!.leaderboard_info_pos + AppContext.user.globalPosition.toString() + AppLocalizations.of(context)!.out_of ) + AppContext.user.totalUsers.toString() : Constants.empty );


    return Scaffold(

        backgroundColor: Colors.white,

        key: UniqueKey(),

    body:

          PageStorage(

              bucket: pageBucket,
              child:


                (leaders.isEmpty) ?

                Align(alignment: Alignment.center,
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            // Icon on top
                              const Icon(
                                Icons.sports_soccer,  // Built-in Flutter icon
                                size: 60,  // Icon size
                                color: Colors.grey, // Icon color
                              ),
                              const SizedBox(height: 20),
                            // Text below the icon
                            Text(
                              AppLocalizations.of(context)!.empty_list,
                                style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(ColorConstants.my_dark_grey),
                              ),
                            ),
                            ],
                        )
                )

           :



              Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
      children: [
      const Icon(Icons.info_outline, color: Colors.blue),
      const SizedBox(width: 8),
      Expanded(
      child: Text(

        infoMsg,
            style: const TextStyle(fontSize: 10, color: Colors.black87),
      ),
      ),
      ],
      ),
      ),
      Expanded(
      child: ListView.builder(
      key: const PageStorageKey<String>('pageLeaderCurr'),
      padding: const EdgeInsets.all(8),
      itemCount: leaders.length,
      itemBuilder: (context, item) {
      User user = leaders[item];
      return _buildUserRow(user, item,  true, isPreviousMonthWinner, 'curr$item${user.mongoUserId}');
      },
      ),
      ),
      ],
      ),


          )

    );


  }

  void getLeaderBoard() async{
    if (isMinimized){
      return;
    }

    Map<String, List<User>> leadersMap = await HttpActionsClient.getLeadingUsers();


    if (leadersMap.isNotEmpty) {
      for (MapEntry leadersEntry in leadersMap.entries) {

          List<User>? existingLeaders = leaders;
          List<User> incomingLeaders = leadersEntry.value;
          for (User u in incomingLeaders){
            User existing = existingLeaders.firstWhere((element) => element.mongoUserId == u.mongoUserId, orElse: () => User.defUser(),);
            if (existing.mongoUserId != Constants.defMongoId){
              existing.deepCopyFrom(u);
            }else{
              existingLeaders.add(u);
            }
          }

          for (User u in List.of(existingLeaders!)){
            if (!incomingLeaders.contains(u)){
              existingLeaders.remove(u);
            }
          }

          if (leadersEntry.key == '0') {
            existingLeaders.sort();
          }
          }


      if (!mounted){
        // print('not mounted');
        return;
      }


      for (var l in leaders) {
        l.userBets.sort();
      }
      setState(() {
        leaders;
      });
    }

  }


  Widget _buildUserRow(User leader, int item, bool isCurrentLeaderBoard, bool isCurrentLeaderBoardWinner, String key) {
    return GlobalLeaderboardRow(user: leader, key: PageStorageKey<String>(key));
    // return LeaderBoardUserFullInfoRow(user: leader, isCurrentLeaderBoard: isCurrentLeaderBoard, isLeaderBoardWinner: isCurrentLeaderBoardWinner, key: PageStorageKey<String>(key));

  }

}