import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTextWithButtons extends StatelessWidget{//} StatefulWidget {

  // final String text;


  // const DialogTextWithButtons({super.key, required this.text});


  // @override
  // State<StatefulWidget> createState() => DialogTextWithButtonsState();
// }

  // class DialogTextWithButtonsState extends State<DialogTextWithButtons>{

  // late String text;

  // @override
  // void initState() {
  //
  //   super.initState();
  //   // text = widget.text;
  // }

    @override
    Widget build(BuildContext context) {
      return

        AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: SizedBox(
          width: 80.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'Your virtual credits are close to 0. /n Do you want to topUp?',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  print("Follow button pressed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[400], // Red color variation
                  onPrimary: Colors.white,  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button size
                ),
                child: const Text(
                  'TopUp',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )
            ],
          ),
        ),

        );
    }


  }

