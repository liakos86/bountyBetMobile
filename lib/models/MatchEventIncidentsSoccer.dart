
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';

import 'MatchEventIncidentSoccer.dart';
import 'Player.dart';
import 'constants/JsonConstants.dart';

class MatchEventIncidentsSoccer{

  List<MatchEventIncidentSoccer> data = <MatchEventIncidentSoccer>[];

  static fromJson(model){
    MatchEventIncidentsSoccer stats = MatchEventIncidentsSoccer();
    Iterable l = model[JsonConstants.data];
    for(var stat in l){
      stats.data.add(MatchEventIncidentSoccer.fromJson(stat));
    }

    return stats;
  }


}