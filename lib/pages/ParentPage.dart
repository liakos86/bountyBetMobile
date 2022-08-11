import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Odd.dart';
import 'package:flutter_app/pages/OddsPage.dart';

import '../models/interfaces/StatefulWidgetWithName.dart';
import 'LeaderBoardPage.dart';
import 'MyBetsPage.dart';

class ParentPage extends StatefulWidget{
  @override
  ParentPageState createState() => ParentPageState();
}

class ParentPageState extends State<ParentPage>{

  bool showOdds = false;

  double finalOdd = 0;

  int _selectedPage = 0;
  final List<Widget> pagesList = <Widget>[];

  @override
  Widget build(BuildContext context) {

    pagesList.add(OddsPage((finalOddValue) => setState(
            ()=> finalOdd = finalOddValue))
    );

    pagesList.add(LeaderBoardPage());
    pagesList.add(MyBetsPage());

    return Scaffold(
      appBar: AppBar(
          title: Text((pagesList[_selectedPage] as StatefulWidgetWithName).name),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: null)]
      ),
      body: pagesList[_selectedPage],

      floatingActionButton: FloatingActionButton(
        onPressed: ()=> setState(() {
          if(!showOdds)
            showOdds = true;
          else
            showOdds = false;
        }),
        child: showOdds ? Icon(Icons.remove) : Text(finalOdd.toStringAsFixed(2), style: TextStyle(fontSize: 16),),
      ),

      bottomSheet:
          showOdds ?

          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: 300,
              minWidth: double.infinity,
              maxWidth: double.infinity
            ),

            child: Center(
              child : Text('Selected odds here')
            ),
          )
      : null
      ,

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        unselectedFontSize: 15,
        backgroundColor: Colors.blueAccent,
        fixedColor: Colors.white,
        currentIndex: _selectedPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Odds'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Leaders'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_music),
              label: 'My bets'
          ),
        ],

        onTap: (index){
          setState(() {
            _selectedPage = index;
          });

        },
      ),

    );
  }


}
