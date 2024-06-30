import 'package:flutter_app/models/constants/Constants.dart';

enum EventIncidentType{

  NONE(incidentCode: Constants.empty),

card(incidentCode: "card"),

goal(incidentCode: "goal"),// search for text in case of penalty
injuryTime(incidentCode: "injuryTime"),
period(incidentCode: "period"),
varDecision(incidentCode: "varDecision"),// the outcome must be cross checked with event's score
substitution(incidentCode: "substitution"),
inGamePenalty(incidentCode: "inGamePenalty");// this means it is missed

  final String incidentCode;

  const EventIncidentType({
    required this.incidentCode
  })  ;

  static EventIncidentType ofStatus(String code){
    for (EventIncidentType status in EventIncidentType.values){
      if (code == status.incidentCode){
        return status;
      }
    }

    print('****** INCIDENT CODE:' + code);

    return EventIncidentType.NONE;
  }

}