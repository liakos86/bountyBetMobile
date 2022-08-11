import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/interfaces/StatefulWidgetWithName.dart';


class MyBetsPage extends StatefulWidgetWithName{

  @override
  MyBetsPageState createState() => MyBetsPageState();

  MyBetsPage(){
    setName('My Bets');
  }

}

class MyBetsPageState extends State<MyBetsPage>{

  @override
  Widget build(BuildContext context) {

    return Container(
       child: Text('My Bets')
    );

  }

}