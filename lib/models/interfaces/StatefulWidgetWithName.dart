import 'package:flutter/material.dart';

class StatefulWidgetWithName extends StatefulWidget{

  String name = '';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  void setName(name){
    this.name = name;
  }

}