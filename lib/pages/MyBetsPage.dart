
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/UserBetRow.dart';
import 'LivePage.dart';


class MyBetsPage extends StatefulWidget{//}WithName{

  final User user;

  final Function loginOrRegisterCallback;


  @override
  MyBetsPageState createState() => MyBetsPageState(user, loginOrRegisterCallback);

  MyBetsPage({
    Key? key,
    required this.user,
    required this.loginOrRegisterCallback
    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class MyBetsPageState extends State<MyBetsPage>  with SingleTickerProviderStateMixin{

  User user;

  Function loginOrRegisterCallback;

  MyBetsPageState(this.user, this.loginOrRegisterCallback);

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    user = widget.user;
    loginOrRegisterCallback = widget.loginOrRegisterCallback;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //userBets = context.user

   if (user.mongoUserId == Constants.defMongoUserId){
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
    for (UserBet bet in user.userBets){
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
            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsPending'),
                // padding: const EdgeInsets.all(8),
                itemCount: pendingBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(pendingBets[item], 'pending$item');
                }),

            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsWon'),
                // padding: const EdgeInsets.all(8),
                itemCount: wonBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(wonBets[item], 'won$item');
                }),

            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsLost'),
                // padding: const EdgeInsets.all(8),
                itemCount: lostBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(lostBets[item], 'lost$item');
                })
          ],)
            )

        ),
    );

  }

  Widget _buildUserBetRow(UserBet bet, String key) {

    return UserBetRow(key: PageStorageKey<String>(key), bet: bet);
  }

}
