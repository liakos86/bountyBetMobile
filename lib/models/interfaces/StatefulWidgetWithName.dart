import 'package:flutter/material.dart';

class StatefulWidgetWithName extends StatefulWidget{

  String name = '';

  StatefulWidgetWithName({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  void setName(name){
    this.name = name;
  }

}