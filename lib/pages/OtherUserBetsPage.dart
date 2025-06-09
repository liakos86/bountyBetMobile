
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/UserBet.dart';

import '../models/User.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../utils/client/HttpActionsClient.dart';
import '../widgets/row/UserBetRow.dart';
import 'LivePage.dart';


class OtherUserBetsPage extends StatefulWidget{//}WithName{

  User otherUser;

  @override
  OtherUserBetsPageState createState() => OtherUserBetsPageState(otherUser);

  OtherUserBetsPage({
    Key? key,
    required this.otherUser
  } ) : super(key: key);

}

class OtherUserBetsPageState extends State<OtherUserBetsPage>  with  WidgetsBindingObserver{

  List<UserBet> bets = <UserBet>[];

  User otherUser = User.defUser();

  bool isMinimized = false;

  OtherUserBetsPageState(User otherUser);

  @override
  void initState(){

    otherUser = widget.otherUser;

    getBetsOfOtherUser(otherUser);
    Timer.periodic(const Duration(seconds: 180), (timer) {
      //if (!isMinimized) {
      getBetsOfOtherUser(otherUser);
        //);
      //}
    }
    );

    super.initState();
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
  Widget build(BuildContext context) {


    bets.sort();

    return

      Scaffold(
        appBar: AppBar(title: Text('Pending bets of ${otherUser.username}', style: const TextStyle(fontSize: 16))),
    body:

    PageStorage(

    bucket: pageBucket,
    child:


      (bets.isEmpty) ?

    const Align(alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icon on top
            ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
            const SizedBox(height: 20),  // Space between icon and text
            // Text below the icon
            const Text(
              'No bets',
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
        itemCount: bets.length,
        itemBuilder: (context, item) {
          UserBet bet = bets[item];
          return _buildUserBetRow(bet, 'otherUserBet$item${bet.betId}');
        })

    )
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

  void getBetsOfOtherUser(User otherUser) async{
    if (isMinimized){
      return;
    }

    List<UserBet> otherUserBets = await HttpActionsClient.getUserBets(otherUser.mongoUserId);
    updateBets(otherUserBets);
  }

}
