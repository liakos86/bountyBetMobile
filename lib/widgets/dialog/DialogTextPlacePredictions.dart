import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/models/constants/PurchaseConstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../enums/BetPlacementStatus.dart';
import '../../models/context/AppContext.dart';

class DialogTextPlacePredictions extends StatefulWidget {
  final Future<BetPlacementStatus> Function(double) confirmCallback; // Ensure it's async
  final String text;

  const DialogTextPlacePredictions({
  super.key,
  required this.confirmCallback,
  required this.text,
  });

  @override
  State<DialogTextPlacePredictions> createState() => _DialogTextPlacePredictionsState();
}

class _DialogTextPlacePredictionsState extends State<DialogTextPlacePredictions> {
  bool _isLoading = false;
  String errorMsg = '';
  Future<void> _onConfirmPressed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.confirmCallback(1.0); // e.g., returns true/false

      if (!mounted) return;

      if (result == BetPlacementStatus.PLACED) {
        Navigator.pop(context); // success - close dialog
      } else {
        setState(() {
          _isLoading = false; // failed - stop loading, stay on dialog
          errorMsg = convertErrorMsg(result);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // error occurred - stay on dialog
        errorMsg = 'error';
      });
      // Optionally: show a snackbar or error message here
    }
  }

  convertErrorMsg(BetPlacementStatus status){
    if (status == BetPlacementStatus.FAILED_MATCH_IN_PROGRESS) {
      return AppLocalizations.of(context)!.match_in_progress;
    }

    if (status == BetPlacementStatus.FAIL_GENERIC) {
      return AppLocalizations.of(context)!.cannot_place_bet;
    }

    if (status == BetPlacementStatus.FAILED_MATCH_IN_NEXT_MONTH) {
     return AppLocalizations.of(context)!.preds_next_month;
    }

    if (status == BetPlacementStatus.FAILED_USER_NOT_VALIDATED){
      return '${AppLocalizations.of(context)!.mail_requires_validation}${AppContext.user.email}';
    }

    if (status == BetPlacementStatus.FAILED_USER_NOT_VALIDATED){
      return AppLocalizations.of(context)!.login_or_register;
    }

    return 'error';
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onConfirmPressed,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          AppLocalizations.of(context)!.confirm_button_text,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(ColorConstants.my_dark_grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel_button_text,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
