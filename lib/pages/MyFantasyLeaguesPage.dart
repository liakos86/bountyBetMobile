
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/FantasyLeague.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/Constants.dart';
import '../models/context/AppContext.dart';
import '../widgets/CustomTabIcon.dart';
import 'LivePage.dart';


class MyFantasyLeaguesPage extends StatefulWidget{//}WithName{

  final Function loginOrRegisterCallback;


  @override
  MyFantasyLeaguesPageState createState() => MyFantasyLeaguesPageState(loginOrRegisterCallback);

  MyFantasyLeaguesPage({
    Key? key,
    required this.loginOrRegisterCallback

    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class MyFantasyLeaguesPageState extends State<MyFantasyLeaguesPage>  with SingleTickerProviderStateMixin{

  List<FantasyLeague> fantasyLeagues = List.of(AppContext.user.fantasyLeagues);

  Function loginOrRegisterCallback;

  MyFantasyLeaguesPageState(this.loginOrRegisterCallback);

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    Timer.periodic(const Duration(seconds: 20), (timer) {
      //if (!isMinimized) {
         updateFantasyLeagues(AppContext.user.fantasyLeagues);
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
            heroTag: 'btnMyFantasyLeaguesLogin',
            icon: const Icon(Icons.navigation),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            onPressed: () => { loginOrRegisterCallback.call()
               },
            label: const Text('Login/Register'),
      ));
    }

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

            tabs: [
              CustomTabIcon(width: labelWidth, text: 'Current League', isSelected: _tabController.index == 0,),
              CustomTabIcon(width: labelWidth,  text: 'Past Leagues', isSelected: _tabController.index == 1,),
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

            (fantasyLeagues.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No league',
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


                Text('TODO'),




            (fantasyLeagues.isEmpty) ?

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

            Text('TODO'),

          ],)
            )

        ),
    );

  }

  void updateFantasyLeagues(List<FantasyLeague> userBets) {
    // for(UserBet incomingBet in userBets){
    //   UserBet existing = bets.firstWhere((element) => element.betId == incomingBet.betId, orElse: () => UserBet.defBet());
    //   if (existing.betId != Constants.defMongoId){
    //     existing.copyFrom(incomingBet);
    //   }else{
    //     bets.add(incomingBet);
    //   }
    // }
    //
    // for(UserBet existingBet in List.of(bets)){
    //   UserBet incoming = userBets.firstWhere((element) => element.betId == existingBet.betId, orElse: () => UserBet.defBet());
    //   if (incoming.betId == Constants.defMongoId){
    //     bets.remove(existingBet);
    //   }
    // }
    //
    // setState((){
    //   bets;
    // });
  }

}
