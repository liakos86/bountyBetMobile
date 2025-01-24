import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogProgressText extends StatefulWidget {

  final String text;


  const DialogProgressText({super.key, required this.text});


  @override
  State<StatefulWidget> createState() => DialogProgressTextState();
}

  class DialogProgressTextState extends State<DialogProgressText>{

  late String text;

  @override
  void initState() {

    super.initState();
    text = widget.text;
  }

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
              const CircularProgressIndicator(),
              const SizedBox(height: 20.0),
              Text(
                text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),

        );
    }


  }

