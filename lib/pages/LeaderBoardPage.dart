import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserAward.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/row/LeaderboardUserRowNew.dart';

import '../models/User.dart';
import '../models/UserMonthlyBalance.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../utils/BetUtils.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/LeaderBoardAwardRow.dart';
import 'LivePage.dart';


class LeaderBoardPage extends StatefulWidget{//}WithName {

  @override
  LeaderBoardPageState createState() => LeaderBoardPageState();

}

class LeaderBoardPageState extends State<LeaderBoardPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  Map<String, List<User>> leaders = {};

  List<UserMonthlyBalance> balances = <UserMonthlyBalance>[];

  late TabController _tabController;

  bool isMinimized = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _tabController.dispose();
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

    leaders['0'] = <User>[];
    leaders['1'] = <User>[];

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addObserver(this); // Add observer


    getLeaderBoard();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getLeaderBoard()
    );
   } );

   getMyBalances();
    Timer.periodic(const Duration(seconds: 30), (timer) {(
        getMyBalances()
    );
    }
   );


  }

  @override
  Widget build(BuildContext context) {

    const int items = 3;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 4;
    double labelWidth = (width - (labelPadding * (items - 1))) / items;


    DateTime dt = DateTime.now();


    return
      Scaffold(
        backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            toolbarHeight: 5,
            backgroundColor: Colors.black87, // const Color(ColorConstants.my_dark_grey),
            bottom: TabBar(
              // isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
              indicator: const BoxDecoration(),
              controller: _tabController,


              tabs: [
                CustomTabIcon(width: labelWidth, text: BetUtils.getLocalizedMonthString(context, dt.month, dt.year), isSelected: _tabController.index == 0,),
                CustomTabIcon(width: labelWidth, text: 'Winners', isSelected: _tabController.index == 1,),
                CustomTabIcon(width: labelWidth, text: 'My stats', isSelected: _tabController.index == 2,),
                // CustomTabIcon(width: labelWidth, text: 'Me all time', isSelected: _tabController.index == 3,),

              ],

              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              }
            ),
          ),

          body:

          PageStorage(

              bucket: pageBucket,
              child:
              TabBarView(
                controller: _tabController,
                children: [

                (leaders["0"] == null || leaders["0"]!.isEmpty) ?

                const Align(alignment: Alignment.center,
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            // Icon on top
                            ImageIcon(size:100, AssetImage('assets/images/leaders-100.png')),
                            SizedBox(height: 20),  // Space between icon and text
                            // Text below the icon
                            Text(
                                'Empty Leader Board..',
                                style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(ColorConstants.my_dark_grey),
                              ),
                            ),
                            ],
                        )
                )

           :

                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderCurr'),
                      padding: const EdgeInsets.all(8),
                      itemCount: leaders["0"]?.length,
                      itemBuilder: (context, item) {
                        User user = leaders["0"]![item];
                        // return _buildUserRow((item+1).toString(), user, 'curr$item${user.mongoUserId}');
                        return _buildUserRow(user, true, 'curr$item${user.mongoUserId}');
                      }),


                  (leaders["1"] == null || leaders["1"]!.isEmpty) ?

                  const Align(alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Icon on top
                          ImageIcon(size:100, AssetImage('assets/images/leaders-100.png')),
                          const SizedBox(height: 20),  // Space between icon and text
                          // Text below the icon
                          const Text(
                            'No winners yet..',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(ColorConstants.my_dark_grey),
                            ),
                          ),
                        ],
                      )
                  )

                      :


                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderAll'),
                      padding: const EdgeInsets.all(8),
                      itemCount: leaders["1"]?.length,
                      itemBuilder: (context, item) {
                        User user = leaders["1"]![item];
                        // return _buildUserRow(BetUtils.getLocalizedMonthString(context, user.balance.month, user.balance.year), user,    'all$item${user.mongoUserId}');
                        return _buildUserRow(user, false,   'all$item${user.mongoUserId}');
                        // return _buildAwardRow(user,    'all$item${user.mongoUserId}');
                      }),


                  (AppContext.user.mongoUserId == User.defUser().mongoUserId
                    || !AppContext.user.validated) ?

                  const Align(alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Icon on top
                          ImageIcon(size:100, AssetImage('assets/images/leaders-100.png')),
                          const SizedBox(height: 20),  // Space between icon and text
                          // Text below the icon
                          const Text(
                            'Please login or validate..',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(ColorConstants.my_dark_grey),
                            ),
                          ),
                        ],
                      )
                  )

                      :

                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageLeaderCurrMe'),
                      padding: const EdgeInsets.all(8),
                      itemCount: balances.length,
                      itemBuilder: (context, item) {
                        UserMonthlyBalance balance = balances.elementAt(item);
                        return _buildBalanceRow(item, balance,    'currme$item${balance.mongoId}');
                      }),


                ],)
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

          List<User>? existingLeaders = leaders[leadersEntry.key];
          List<User> incomingLeaders = leadersEntry.value;
          for (User u in incomingLeaders){
            User existing = existingLeaders!.firstWhere((element) => element.mongoUserId == u.mongoUserId, orElse: () => User.defUser(),);
            if (existing.mongoUserId != Constants.defMongoId){
              existing.copyBalancesFrom(u);
            }else{
              existingLeaders.add(u);
            }
          }

          for (User u in List.of(existingLeaders!)){
            if (!incomingLeaders.contains(u)){
              existingLeaders.remove(u);
            }
          }

          existingLeaders.sort();
      }

      if (!mounted){
        // print('not mounted');
        return;
      }


      setState(() {
        leaders;
      });
    }

  }

  void getMyBalances() async{
    if (isMinimized || AppContext.user.mongoUserId == Constants.defMongoId){
      return;
    }

    List<UserMonthlyBalance> incomingBalances = await HttpActionsClient.getUserBalancesAsync(AppContext.user.mongoUserId);


    if (incomingBalances.isNotEmpty) {
      for (UserMonthlyBalance incomingBalance in incomingBalances) {
        UserMonthlyBalance existing = balances.firstWhere((element) => element.mongoId == incomingBalance.mongoId, orElse: () => UserMonthlyBalance.defBalance(),);
          if (existing.mongoId != Constants.defMongoId){
            existing.copyBalancesFrom(incomingBalance);
          }else{
            balances.add(incomingBalance);
          }
        }

        for (UserMonthlyBalance existing in List.of(balances)){
          UserMonthlyBalance incoming = incomingBalances.firstWhere((element) => element.mongoId == existing.mongoId, orElse: () => UserMonthlyBalance.defBalance(),);
          if (incoming.mongoId == Constants.defMongoId){
            balances.remove(existing);
          }
        }

      balances.sort();
      }

      if (!mounted){
        // print('not mounted');
        return;
      }


      setState(() {
        balances;
      });
    }




  Widget _buildUserRow(User leader, bool isCurrentLeaderBoard, String key) {
    return LeaderBoardUserFullInfoRow(user: leader, isCurrentLeaderBoard: isCurrentLeaderBoard, key: PageStorageKey<String>(key));

  }

  // Widget _buildAwardRow( User leader, String key) {
  //
  //   UserMonthlyBalance award = leader.balance;
  //
  //   return LeaderBoardAwardRow(award: award, username: leader.username, key: PageStorageKey<String>(key));
  //
  // }

  Widget _buildBalanceRow(int item, UserMonthlyBalance balance, String key) {
    User user = User.defUser();
    user.username = AppContext.user.username;
    user.balance = balance;

    return LeaderBoardUserFullInfoRow(user: user, isCurrentLeaderBoard: false, key: PageStorageKey<String>(key));
  }


}