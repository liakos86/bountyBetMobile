
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/row/UserBetRow.dart';
import 'LivePage.dart';


class MyBetsPage extends StatefulWidgetWithName{

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

class MyBetsPageState extends State<MyBetsPage>{

  User user;

  Function loginOrRegisterCallback;

  MyBetsPageState(this.user, this.loginOrRegisterCallback);

  @override
  void initState(){
    user = widget.user;
    loginOrRegisterCallback = widget.loginOrRegisterCallback;
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 2,
         backgroundColor: Colors.deepOrange.shade100,

          bottom: TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: Colors.red,
            indicatorWeight: 8,

            tabs: [
              Tab( text: 'Pending(${pendingBets.length.toString()})'),
              Tab( text: 'Won(${wonBets.length.toString()})',),
              Tab( text: 'Lost(${lostBets.length.toString()})',),
            ],
          ),
        ),

        body:

            PageStorage(

          bucket: pageBucket,
        child:
        TabBarView(
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
