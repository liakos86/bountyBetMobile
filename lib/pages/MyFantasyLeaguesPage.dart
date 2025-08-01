import 'dart:async';
import 'dart:ui';
import 'package:collection/collection.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';


import '../models/FantasyLeagueInvitation.dart';
import '../models/User.dart';
import '../models/constants/ColorConstants.dart';
import '../widgets/custom/FantasyLeagueCard.dart';
import '../widgets/row/FantasyLeagueInvitationRow.dart';
import '../widgets/dialog/DialogWizardLeagueNameStep1.dart';
import 'LivePage.dart';





import 'package:flutter/widgets.dart';

import '../models/FantasyLeague.dart';
import '../widgets/CustomTabIcon.dart';


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

  FantasyLeague? fantasyLeague;

  List<FantasyLeague> fantasyLeagues = <FantasyLeague>[];

  List<FantasyLeague> invitations = <FantasyLeague>[];

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
    loginOrRegisterCallback= widget.loginOrRegisterCallback;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    Timer.periodic(const Duration(seconds: 15), (timer) {
      //if (!isMinimized) {
         updateFantasyLeagues();
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

   const int items = 3;
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
              CustomTabIcon(width: labelWidth,  text: 'Invitations', isSelected: _tabController.index == 1,),
              CustomTabIcon(width: labelWidth,  text: 'Past Leagues', isSelected: _tabController.index == 2,),
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

            (AppContext.user.fantasyLeagueMongoId == null) ?

            Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              DialogWizardLeagueNameStep1(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create League"),
                    ),

                  ],
                )
            )

                :


            fantasyLeague != null ?

        FantasyLeagueCard(
          fantasyLeague: fantasyLeague,
          onOptOut: () {

            optout();


            print("Opted out!");
          },
          onInviteEmail: (email) async{
            FantasyLeagueInvitation invitation = FantasyLeagueInvitation(email: email);
            invitation = await HttpActionsClient.createFantasyLeagueInvitation(invitation);
            print('Invited: $email');
          },
        )

                : SizedBox(),




                // Text(AppContext.user.fantasyLeagueMongoId??'no mongo id'),




            (invitations.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    ImageIcon(size:100, AssetImage('assets/images/money-bag-100.png')),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No invitations',
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
              key: const PageStorageKey<String>('pageLeaguesInvitations'),
              padding: const EdgeInsets.all(8),
              itemCount: invitations.length,
              itemBuilder: (context, item) {
                return _buildInvitationRow(invitations[item], 'inv$item${invitations[item].mongoId}');
              },
            ),
            


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
                      'No completed leagues',
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

            Text(fantasyLeagues[0].name),


          ],)
            )

        ),
    );

  }

  void updateFantasyLeagues() async{
    List<FantasyLeague> leagues = await HttpActionsClient.getFantasyLeaguesAsync();

    if (AppContext.user.fantasyLeagueMongoId != null) {
      FantasyLeague? fantasyLeagueIncoming = leagues.firstWhereOrNull((element) => element.mongoId == AppContext.user.fantasyLeagueMongoId);
      if (fantasyLeagueIncoming != null){
        if (fantasyLeague == null){
          fantasyLeague = fantasyLeagueIncoming;
        }else{
          fantasyLeague?.copyFrom(fantasyLeagueIncoming);
        }
      }
    }

    if (fantasyLeague != null){
      for (int id in  List.of(AppContext.fantasyLeagueIds)){
        if (!fantasyLeague!.selectedLeagueIds.contains(id)){
          AppContext.fantasyLeagueIds.remove(id);
        }
      }

      for (int id in  fantasyLeague!.selectedLeagueIds){
        if (!AppContext.fantasyLeagueIds.contains(id)){
          AppContext.fantasyLeagueIds.add(id);
        }
      }
    }


    List<FantasyLeague> invitationsIncoming = (leagues.where((e) => e.isInvitation).toList());
    for (FantasyLeague invitationIncoming in invitationsIncoming){
      FantasyLeague? invitationExisting = invitations.firstWhereOrNull((element) => element.mongoId == invitationIncoming.mongoId);
      if (invitationExisting != null){
        invitationExisting.copyFrom(invitationIncoming);
      }else{
        invitations.add(invitationIncoming);
      }
    }

    //TODO
    fantasyLeagues.clear();
    fantasyLeagues.addAll(leagues.where((e) => !e.isInvitation && e.mongoId != AppContext.user.fantasyLeagueMongoId));



  }

  Widget _buildInvitationRow(FantasyLeague league, String key) {
    return FantasyLeagueInvitationRow(
      key: PageStorageKey<String>(key),
      league: league,
      onAccept: () {
        print("Accepted invitation");
        FantasyLeagueInvitation fli = FantasyLeagueInvitation(email: AppContext.user.email);
        fli.mongoId = league.invitationMongoId;
        HttpActionsClient.acceptFantasyLeagueInvitation(fli);
      },
      onDecline: () {
        print("Declined invitation");
        // TODO: Call backend / update state
      },
    );
  }

  void optout() async{
    User user = await HttpActionsClient.optOutFantasyLeague();
    if (user.fantasyLeagueMongoId == null){
      setState(() {
        fantasyLeague = null;
        AppContext.user.fantasyLeagueMongoId = null;
      });
    }
  }



}
