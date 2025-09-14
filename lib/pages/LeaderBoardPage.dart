import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/row/LeaderBoardUserFullInfoRow.dart';
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
   Timer.periodic(const Duration(seconds: 30), (timer) {(
       getLeaderBoard()
   );
   } );

   // getMyBalances();
   //  Timer.periodic(const Duration(seconds: 30), (timer) {(
   //      getMyBalances()
   //  );
   //  }
   // );


  }

  @override
  Widget build(BuildContext context) {
    // DateTime dt = DateTime.now();
    //
    // const int items = 1;
    // double width = MediaQuery.of(context).size.width;
    // const double labelPadding = 0;
    // double labelWidth = (width - (labelPadding * (items - 1))) / items;


    String infoMsg = AppLocalizations.of(context)!.leaderboard_info
        + (

        AppContext.user.mongoUserId != Constants.defMongoId ?

    (AppLocalizations.of(context)!.leaderboard_info_pos + AppContext.user.globalPosition.toString() + AppLocalizations.of(context)!.out_of ) + AppContext.user.totalUsers.toString() : Constants.empty );


    // return
      // Scaffold(
      //   backgroundColor: Colors.grey.shade50,
      //     appBar: AppBar(
      //       toolbarHeight: 5,
      //       backgroundColor: Colors.black87, // const Color(ColorConstants.my_dark_grey),
      //       bottom: TabBar(
      //         // isScrollable: true,
      //         labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
      //         indicator: const BoxDecoration(),
      //         controller: _tabController,
      //
      //
      //         tabs: [
      //           CustomTabIcon(width: labelWidth, text: BetUtils.getLocalizedMonthString(context, dt.month, dt.year), isSelected: _tabController.index == 0,),
      //           // CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.winners, isSelected: _tabController.index == 1,),
      //           // CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.me, isSelected: _tabController.index == 2,),
      //           // CustomTabIcon(width: labelWidth, text: 'Me all time', isSelected: _tabController.index == 3,),
      //
      //         ],
      //
      //         onTap: (index) {
      //           setState(() {
      //             _tabController.index = index;
      //           });
      //         }
      //       ),
      //     ),
      //
      //     body:

    return Scaffold(

        backgroundColor: Colors.white,

        key: UniqueKey(),

    body:

          PageStorage(

              bucket: pageBucket,
              child:

              // TabBarView(
              //   controller: _tabController,
              //   children: [

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
                                fontSize: 16,
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





          // (leaders["1"] == null || leaders["1"]!.isEmpty) ?
          //
          //         Align(alignment: Alignment.center,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 // Icon on top
          //                 const ImageIcon(size:100, AssetImage('assets/images/leaders-100.png')),
          //                 const SizedBox(height: 20),  // Space between icon and text
          //                 // Text below the icon
          //                 Text(
          //                   AppLocalizations.of(context)!.empty_list,
          //                   style: const TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                     color: Color(ColorConstants.my_dark_grey),
          //                   ),
          //                 ),
          //               ],
          //             )
          //         )
          //
          //             :
          //
          //
          //         ListView.builder(
          //             key: const PageStorageKey<String>(
          //                 'pageLeaderAll'),
          //             padding: const EdgeInsets.all(8),
          //             itemCount: leaders["1"]?.length,
          //             itemBuilder: (context, item) {
          //               User user = leaders["1"]![item];
          //               return _buildUserRow(user, false,  false, 'all$item${user.mongoUserId}');
          //             }),
          //
          //
          //         (AppContext.user.mongoUserId == User.defUser().mongoUserId
          //           || !AppContext.user.validated) ?
          //
          //         Align(alignment: Alignment.center,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 // Icon on top
          //                 const ImageIcon(size:100, AssetImage('assets/images/leaders-100.png')),
          //                 const SizedBox(height: 20),  // Space between icon and text
          //                 // Text below the icon
          //                 Text(
          //                   AppLocalizations.of(context)!.login_or_validate,//'Please login or validate..',
          //                   style: const TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                     color: Color(ColorConstants.my_dark_grey),
          //                   ),
          //                 ),
          //               ],
          //             )
          //         )
          //
          //             :
          //
          //         ListView.builder(
          //             key: const PageStorageKey<String>(
          //                 'pageLeaderCurrMe'),
          //             padding: const EdgeInsets.all(8),
          //             itemCount: balances.length,
          //             itemBuilder: (context, item) {
          //               UserMonthlyBalance balance = balances.elementAt(item);
          //               return _buildBalanceRow(item, balance,    'currme$item${balance.mongoId}');
          //             }),


                // ],
              // )
          )

      // ),
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
          // else{
          //   existingLeaders.sort((a, b) {
          //     // First compare by year (descending)
          //     int yearComparison = b.balance.year.compareTo(a.balance.year);
          //     if (yearComparison != 0) return yearComparison;
          //
          //     // If years are equal, compare by month (descending)
          //     return b.balance.month.compareTo(a.balance.month);
          //   });
          // }
      }

      // List<User>? previousMonthWinners = leaders["2"];
      // checkMonthWinnerNotification(previousMonthWinners);


      if (!mounted){
        // print('not mounted');
        return;
      }


      setState(() {
        leaders;
      });
    }

  }


  Widget _buildUserRow(User leader, int item, bool isCurrentLeaderBoard, bool isCurrentLeaderBoardWinner, String key) {
    return GlobalLeaderboardRow(user: leader, position: item+1, key: PageStorageKey<String>(key));
    // return LeaderBoardUserFullInfoRow(user: leader, isCurrentLeaderBoard: isCurrentLeaderBoard, isLeaderBoardWinner: isCurrentLeaderBoardWinner, key: PageStorageKey<String>(key));

  }

  Widget _buildBalanceRow(int item, UserMonthlyBalance balance, String key) {
    User user = User.defUser();
    user.mongoUserId = AppContext.user.mongoUserId;
    user.username = AppContext.user.username;
    // user.balance = balance;


    return GlobalLeaderboardRow(user: user, position: item, key: PageStorageKey<String>(key));
    return LeaderBoardUserFullInfoRow(user: user, isCurrentLeaderBoard: false, isLeaderBoardWinner: false, key: PageStorageKey<String>(key));
  }

}