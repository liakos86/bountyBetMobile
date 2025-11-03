import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  //String? _error;
  // Function(FantasyLeague) updateCallback = (a)=>{} ;

  // @override
  // void initState() {
  //   updateCallback = widget.updateCallback;
  // }


  void _onNext() {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length > 50 || name.length < 3) {
      Fluttertoast.showToast(
        msg: "Name must be between 3 and 50 characters",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );

    } else {
      // Proceed to next step, pass name along
      Navigator.of(context).pop(); // Close this dialog
      _showNextStep(context, name, widget.products); // Open next dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.step1_league_name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.step1_select_league,
              //errorText: _error,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _onNext,
          child: Text(AppLocalizations.of(context)!.next),
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
