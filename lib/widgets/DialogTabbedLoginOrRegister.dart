

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/DialogLogin.dart';

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
        resizeToAvoidBottomInset: false,

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: false,
                indicatorColor: Colors.red,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.grey.withOpacity(0.5),

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