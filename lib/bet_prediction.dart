import 'dart:ui';

import 'package:flutter_app/match_event.dart';

class BetPrediction{

  MatchEvent selectedEvent = MatchEvent();

  String selectedOdd = '';//reflection name of field, e.g. 'odd_x'

  MatchEvent getSelectedEvent(){
    return selectedEvent;
  }

  String getSelectedOdd(){
    return selectedOdd;
  }

  void setSelectedOdd(String selectedOdd){
    this.selectedOdd = selectedOdd;
  }

  @override
  operator ==(other) =>
      other is BetPrediction &&
          other.selectedEvent == selectedEvent;

  @override
  int get hashCode => hashValues(selectedEvent, selectedOdd);

}