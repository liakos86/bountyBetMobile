import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';

import '../../models/FantasyLeague.dart';
import 'DialogWizardLeagueLeaguesStep2.dart';

class DialogWizardLeagueNameStep1 extends StatefulWidget {

  final Function(FantasyLeague) updateCallback;

  final Function() alertDialogExtraLeaguesCallback;

  final List<ProductDetails> products;

  DialogWizardLeagueNameStep1({Key? key, required this.updateCallback, required this.products, required this.alertDialogExtraLeaguesCallback}) : super (key: key);




  @override
  State<DialogWizardLeagueNameStep1> createState() => _LeagueNameDialogState();
}

class _LeagueNameDialogState extends State<DialogWizardLeagueNameStep1> {
  final TextEditingController _nameController = TextEditingController();
  String? _error;
  // Function(FantasyLeague) updateCallback = (a)=>{} ;

  // @override
  // void initState() {
  //   updateCallback = widget.updateCallback;
  // }


  void _onNext() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = "Name is required.");
    } else if (name.length > 50) {
      setState(() => _error = "Name cannot exceed 50 characters.");
    } else {
      // Proceed to next step, pass name along
      Navigator.of(context).pop(); // Close this dialog
      _showNextStep(context, name, widget.products); // Open next dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Step 1: League Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: "League Name",
              errorText: _error,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _onNext,
          child: const Text("Next"),
        ),
      ],
    );
  }

  void _showNextStep(BuildContext context, String name, List<ProductDetails> products) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogWizardLeagueLeaguesStep2(leagueName: name, updateCallback: widget.updateCallback, products: products, alertDialogExtraLeagues: widget.alertDialogExtraLeaguesCallback,),
    );
  }

}
