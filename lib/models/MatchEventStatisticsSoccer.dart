
import 'package:flutter_app/models/MatchEventStatisticSoccer.dart';

import 'constants/JsonConstants.dart';

class MatchEventStatisticsSoccer{

  List<MatchEventStatisticSoccer> data = <MatchEventStatisticSoccer>[];

  static fromJson(model){
    MatchEventStatisticsSoccer stats = MatchEventStatisticsSoccer();
    Iterable l = model[JsonConstants.data];
    for(var stat in l){
      stats.data.add(MatchEventStatisticSoccer.fromJson(stat));
    }

    return stats;
  }

}