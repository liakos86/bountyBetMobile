import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/models/constants/PurchaseConstants.dart';

class DialogTextWithButtons extends StatelessWidget{//} StatefulWidget {

  // final String text;

  final Function topUpCallback;

  const DialogTextWithButtons({super.key, required this.topUpCallback});


  // const DialogTextWithButtons({super.key, required this.text});


  // @override
  // State<StatefulWidget> createState() => DialogTextWithButtonsState();
// }

  // class DialogTextWithButtonsState extends State<DialogTextWithButtons>{

  // late String text;


    @override
    Widget build(BuildContext context) {
      var width = MediaQuery
          .of(context)
          .size
          .width;

      return

        AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content:
            Builder(
            builder: (context) {
             return SizedBox(width: width,

                  //height: 100,

                  child:


        // SizedBox(
        //   width: 10,
        //   child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'Your virtual credits are close to 0. Do you want to topUp?',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),

              Row(
                mainAxisSize: MainAxisSize.max,
                children:[

                  Expanded(flex:1, child:

              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  Navigator.pop(context);
                  topUpCallback.call(PurchaseConstants.topup1000);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red[400],  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                ),
                child: const Text(

                  'Top Up 1000',
                  maxLines: 1,
                  style: TextStyle(

                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )),

                  Expanded(flex:1, child:
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      Navigator.pop(context);
                      topUpCallback.call(PurchaseConstants.topup3000);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red[400],  // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded radius
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                    ),
                    child: const Text(
                      'Top Up 3000',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  )),




                  ]
              ),

          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children:[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(ColorConstants.my_dark_grey),  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )
              // ])

        ]
        )

              );
            }
      )
            // ],
          // ),
        // ),

        );
    }


  }

