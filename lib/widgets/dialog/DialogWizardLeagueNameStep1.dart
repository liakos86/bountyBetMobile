import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DialogWizardLeagueLeaguesStep2.dart';

class DialogWizardLeagueNameStep1 extends StatefulWidget {
  @override
  State<DialogWizardLeagueNameStep1> createState() => _LeagueNameDialogState();
}

class _LeagueNameDialogState extends State<DialogWizardLeagueNameStep1> {
  final TextEditingController _nameController = TextEditingController();
  String? _error;

  void _onNext() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = "Name is required.");
    } else if (name.length > 50) {
      setState(() => _error = "Name cannot exceed 50 characters.");
    } else {
      // Proceed to next step, pass name along
      Navigator.of(context).pop(); // Close this dialog
      _showNextStep(context, name); // Open next dialog
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

  void _showNextStep(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogWizardLeagueLeaguesStep2(leagueName: name),
    );
  }

}
