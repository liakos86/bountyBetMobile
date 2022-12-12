import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/DialogLogin.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
import 'package:http/http.dart';

import '../models/UserBet.dart';
import '../models/UserPrediction.dart';
import '../models/constants/UrlConstants.dart';
import '../models/league.dart';
import '../utils/BetUtils.dart';
import '../widgets/BetSlipBottom.dart';
import 'DialogRegister.dart';


class DialogTabbedLoginOrRegister extends StatelessWidget {

  Function registerCallback = ()=>{ };

  Function loginCallback = ()=>{ };

  DialogTabbedLoginOrRegister({
    required this.registerCallback,
    required this.loginCallback,
    //setName('Today\'s Odds')

  } ) ;


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 1,
      length: 2,

      child:

      Scaffold(

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: false,
                indicatorColor: Colors.red,
                indicatorWeight: 1,
                unselectedLabelColor: Colors.white.withOpacity(0.3),

              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Register'),

              ],
            ),


      ),

          body: TabBarView(
            children: [
              DialogLogin(callback: loginCallback),

              DialogRegister(callback: registerCallback),

            ],),


      ),
    );
  }


}