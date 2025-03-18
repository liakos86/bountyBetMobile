
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../models/context/AppContext.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/UserBetRow.dart';
import 'LivePage.dart';


class MyBetsPage extends StatefulWidget{//}WithName{


  final Function loginOrRegisterCallback;


  @override
  MyBetsPageState createState() => MyBetsPageState(loginOrRegisterCallback);

  MyBetsPage({
    Key? key,
    // required this.bets,
    required this.loginOrRegisterCallback
    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class MyBetsPageState extends State<MyBetsPage>  with SingleTickerProviderStateMixin{

  List<UserBet> bets = List.of(AppContext.user.userBets);

  Function loginOrRegisterCallback;

  MyBetsPageState(this.loginOrRegisterCallback);

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    // bets = widget.bets;
    loginOrRegisterCallback = widget.loginOrRegisterCallback;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    Timer.periodic(const Duration(seconds: 20), (timer) {
      //if (!isMinimized) {
         updateBets(AppContext.user.userBets);
        //);
      //}
    }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //userBets = context.user

   if (AppContext.user.mongoUserId == Constants.defMongoId){
      return

        Align(
          alignment: Alignment.center,
          child:
          FloatingActionButton.extended(
            heroTag: 'btnMyBetsLogin',
            icon: const Icon(Icons.navigation),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            onPressed: () => { loginOrRegisterCallback.call() },
            label: const Text('Login/Register'),
      ));
    }

    List<UserBet> pendingBets = <UserBet>[];
    List<UserBet> wonBets = <UserBet>[];
    List<UserBet> lostBets = <UserBet>[];
    for (UserBet bet in bets){
      if (BetStatus.PENDING == bet.betStatus){
        pendingBets.add(bet);
      }else if (BetStatus.WON == bet.betStatus){
        wonBets.add(bet);
      }else{
        lostBets.add(bet);
      }

    }

    pendingBets.sort();
    wonBets.sort();
    lostBets.sort();

   const int items = 4;
   double width = MediaQuery.of(context).size.width;
   const double labelPadding = 4;
   double labelWidth = (width - (labelPadding * (items - 1))) / items;

    return DefaultTabController(
      length: items,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 5,
         backgroundColor: Colors.black87,

          bottom: TabBar(
              // isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
            indicator: const BoxDecoration(),
            controller: _tabController,
            //labelColor: Colors.black87,
            //unselectedLabelColor: Colors.grey[400],
            //indicatorColor: Colors.red,
            //indicatorWeight: 8,

            tabs: [
              CustomTabIcon(width: labelWidth, text: 'Pending(${pendingBets.length.toString()})', isSelected: _tabController.index == 0,),
              CustomTabIcon(width: labelWidth,  text: 'Won(${wonBets.length.toString()})', isSelected: _tabController.index == 1,),
              CustomTabIcon(width: labelWidth,  text: 'Lost(${lostBets.length.toString()})', isSelected: _tabController.index == 2,),
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

            (pendingBets.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No pending bets',
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
                    'pageBetsPending'),
                // padding: const EdgeInsets.all(8),
                itemCount: pendingBets.length,
                itemBuilder: (context, item) {
                  UserBet bet = pendingBets[item];
                  return _buildUserBetRow(bet, 'pending$item${bet.betId}');
                }),


            (wonBets.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No won bets',
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
                    'pageBetsWon'),
                // padding: const EdgeInsets.all(8),
                itemCount: wonBets.length,
                itemBuilder: (context, item) {
                  UserBet bet = wonBets[item];
                  return _buildUserBetRow(bet, 'won$item${bet.betId}');
                }),


            (lostBets.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No lost bets',
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
                    'pageBetsLost'),
                // padding: const EdgeInsets.all(8),
                itemCount: lostBets.length,
                itemBuilder: (context, item) {
                  UserBet bet = lostBets[item];
                  return _buildUserBetRow(bet, 'lost$item${bet.betId}');
                })
          ],)
            )

        ),
    );

  }

  Widget _buildUserBetRow(UserBet bet, String key) {

    return UserBetRow(key: PageStorageKey<String>(key), bet: bet);
  }

  void updateBets(List<UserBet> userBets) {
    for(UserBet incomingBet in userBets){
      UserBet existing = bets.firstWhere((element) => element.betId == incomingBet.betId, orElse: () => UserBet.defBet());
      if (existing.betId != Constants.defMongoId){
        existing.copyFrom(incomingBet);
      }else{
        bets.add(incomingBet);
      }
    }

    for(UserBet existingBet in List.of(bets)){
      UserBet incoming = userBets.firstWhere((element) => element.betId == existingBet.betId, orElse: () => UserBet.defBet());
      if (incoming.betId == Constants.defMongoId){
        bets.remove(existingBet);
      }
    }

    setState((){
      bets;
    });
  }

}
