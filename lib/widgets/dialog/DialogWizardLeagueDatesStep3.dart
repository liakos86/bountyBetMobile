import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/FantasyLeague.dart';
import '../../models/context/AppContext.dart';
import '../../utils/client/HttpActionsClient.dart';
import 'DialogWizardLeagueConfirmStep5.dart';
import 'DialogWizardLeagueOptionsStep4.dart';

class DialogWizardLeagueDatesStep3 extends StatefulWidget {
  final String leagueName;
  final List<int> selectedLeagueIds;

  const DialogWizardLeagueDatesStep3({
    required this.leagueName,
    required this.selectedLeagueIds,
  });

  @override
  State<DialogWizardLeagueDatesStep3> createState() => _DialogWizardLeagueDatesStep3State();
}

class _DialogWizardLeagueDatesStep3State extends State<DialogWizardLeagueDatesStep3> {
  DateTime? _start;
  DateTime? _end;
  String? _error;

  // final DateTime _now = DateTime.now();
  final DateTime _now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 1);

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _start ?? _now.add(Duration(days: 3)),
      firstDate: _now.add(Duration(days: 3)),
      lastDate: _now.add(Duration(days: 365 * 2)),
      helpText: 'Select Start Date',
    );

    if (picked != null) {
      setState(() {
        _start = picked;
        // Reset end if it's invalid now
        if (_end != null && !_isEndValid(picked, _end!)) {
          _end = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_start == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: _end ?? _start!.add(Duration(days: 1)),
      firstDate: _start!.add(Duration(days: 1)),
      lastDate: _start!.add(Duration(days: 366)),
      helpText: 'Select End Date',
    );

    if (picked != null) {
      setState(() {
        _end = picked;
      });
    }
  }

  bool _isEndValid(DateTime start, DateTime end) {
    final duration = end.difference(start);
    return duration.inDays > 0 && duration.inDays <= 366;
  }

  void _onNext() {
    setState(() => _error = null);

    if (_start == null || _end == null) {
      _error = "Please select both start and end dates.";
    } else if (_start!.isBefore(_now.add(Duration(days: 3)))) {
      _error = "Start date must be at least 3 days from today.";
    } else if (!_isEndValid(_start!, _end!)) {
      _error = "End date must be after start and within 1 year.";
    }

    if (_error != null) {
      setState(() {}); // Show error
      return;
    }

    final league = FantasyLeague(
      isInvitation: false,
      creatorUserId: AppContext.user.mongoUserId,
      status: 1,
      name: widget.leagueName,
      dtStart: _start!,
      dtEnd: _end!,
      selectedLeagueIds: widget.selectedLeagueIds,
      startingBalance: 0,//update next
      allowTopUp: false//update next
    );

    Navigator.of(context).pop(); // Close current step

    _showNextStep(context, league);
  }

  void _showNextStep(BuildContext context, FantasyLeague league) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogWizardLeagueOptionsStep4(league: league),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Step 3: Select Dates"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _pickStartDate,
                      child: Text(_start != null ? _dateFormat.format(_start!) : "Select"),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text("End Date", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _start == null ? null : _pickEndDate,
                      child: Text(_end != null ? _dateFormat.format(_end!) : "Select"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.red)),
          ]
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
}
