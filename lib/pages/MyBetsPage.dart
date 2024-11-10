
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

  //HashMap eventsPerIdMap = HashMap();

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
    List<UserBet> settledBets = <UserBet>[];
    for (UserBet bet in user.userBets){
      if (BetStatus.PENDING == bet.betStatus){
        pendingBets.add(bet);
      }else{
        settledBets.add(bet);
      }

    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
         backgroundColor: Colors.blueAccent,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.red,
            indicatorWeight: 8,

            tabs: [
              Tab( text: 'All(${user.userBets.length}}'),
              Tab( text: 'Open(${pendingBets.length.toString()})',),
              Tab( text: 'Settled(${settledBets.length.toString()})',),
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
                    'pageBetsAll'),
                padding: const EdgeInsets.all(8),
                itemCount: user.userBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(user.userBets[item], 'all$item');
                }),

            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsPending'),
                padding: const EdgeInsets.all(8),
                itemCount: pendingBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(pendingBets[item], 'pending$item');
                }),

            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsLost'),
                padding: const EdgeInsets.all(8),
                itemCount: settledBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(settledBets[item], 'settled$item');
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
