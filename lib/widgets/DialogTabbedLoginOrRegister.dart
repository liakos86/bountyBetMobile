

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/DialogLogin.dart';

import 'DialogRegister.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class DialogTabbedLoginOrRegister extends StatelessWidget {

  late final Function registerCallback;

  late final Function loginCallback;

  DialogTabbedLoginOrRegister({
    required this.registerCallback,
    required this.loginCallback,
    //setName('Today\'s Odds')

  }) ;


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 1,
      length: 2,

      child:

      Scaffold(
        // resizeToAvoidBottomInset: false,

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: false,
                indicatorColor: Colors.red,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.grey.withOpacity(0.5),

              tabs: [
                Tab(text: AppLocalizations.of(context)!.login),
                Tab(text: AppLocalizations.of(context)!.register),

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