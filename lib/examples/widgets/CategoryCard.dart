import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import 'CategoryIcon.dart';

class CategoryCard extends StatelessWidget{

  Category category;

  CategoryCard({
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(20), // every row of list has margin of 20 across all directions
        height: 150, // every row of list has height 150
        child: Stack( // the row will be drawn as items on top of each other
          children: [
            Positioned.fill(child: ClipRRect(
              borderRadius : BorderRadius.circular(20),
              child:  Image.asset('assets/images/' + category.imgName + '.png',
                  fit: BoxFit.cover),
            )
            ),
            Positioned(
                bottom:0,
                right: 0,
                left : 0,
                child: Container(

                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent
                            ]
                        )
                    )
                )),
            Positioned(bottom : 0,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [

                    CategoryIcon(
                      iconName: category.icon,
                      color: category.color,

                    ),
                    SizedBox(width: 10),
                    Text(category.name, style: TextStyle(fontSize: 25, color: Colors.white),)

                  ],)
              ),



            )
          ],
        )


    );
  }
}