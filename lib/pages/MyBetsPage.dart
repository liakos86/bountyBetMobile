
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/interfaces/StatefulWidgetWithName.dart';
import '../widgets/UserBetRow.dart';


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

  // eventsPerIdMap = HashMap();

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

        Container(child: Align(
          alignment: Alignment.center,
          child:
          FloatingActionButton.extended(
            icon: const Icon(Icons.navigation),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            onPressed: () => { loginOrRegisterCallback.call() },
            label: const Text('Login/Register'),
      ))
      );
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
         // backgroundColor: Colors.blue[700],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[200],
            indicatorColor: Colors.red,
            indicatorWeight: 8,

            tabs: [
              Tab( text: 'All(${user.userBets.length}}'),
              Tab( text: 'Open(${pendingBets.length.toString()})',),
              Tab( text: 'Settled(${settledBets.length.toString()})',),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: user.userBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(user.userBets[item]);
                }),

            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: pendingBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(pendingBets[item]);
                }),

            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: settledBets.length,
                itemBuilder: (context, item) {
                  return _buildUserBetRow(settledBets[item]);
                })
          ],)

        ),
    );

  }

  Widget _buildUserBetRow(UserBet bet) {

    return UserBetRow(bet);
  }

}
