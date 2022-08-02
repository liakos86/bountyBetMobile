import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/models/category.dart';
import 'package:flutter_app/examples/util/MockUtils.dart';
import 'package:flutter_app/examples/widgets/CategoryCard.dart';
import 'package:flutter_app/examples/widgets/CategoryIcon.dart';

import '../widgets/IconFont.dart';

class CategoryListPage extends StatelessWidget{

  List<Category> categories = MockUtils.mockCategories();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     drawer: Drawer(),
     appBar: AppBar(),
     body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                child : Text('Welcome to the categories selection',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green.shade500),)
            ),
            Expanded(child:
            ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext ctx, int index){
                    return CategoryCard(category : categories[index]);
                })


            )
          ],
        )
     )
   );
  }
}