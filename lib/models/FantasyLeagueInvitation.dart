
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:intl/intl.dart';

import '../enums/FantasyLeagueInvitationStatus.dart';
import 'context/AppContext.dart';


class FantasyLeagueInvitation implements Comparable<FantasyLeagueInvitation>{

  FantasyLeagueInvitation({
    required this.email,


  });

  String errorMsg = Constants.empty;

  String mongoId = Constants.empty;

  int status = FantasyLeagueInvitationStatus.PENDING.statusCode;

  DateTime dtExpiration = DateTime.now();

  String email;

  String fantasyLeagueMongoId = Constants.empty;


  static Future<FantasyLeagueInvitation> fromJson(Map<String, dynamic> parsedJson) async{

    String mongoId = parsedJson['mongoId'] ?? Constants.empty;
    String fantasyLeagueMongoId = parsedJson['fantasyLeagueMongoId'] ?? Constants.empty;
    String email = parsedJson['email'] ?? Constants.empty;
    int status = parsedJson['status'] as int;

    DateFormat formatter = DateFormat("MMM d, yyyy, h:mm:ss a");
    DateTime dtExpiration = parsedJson['dtExpiration'] != null ? formatter.parse(parsedJson['dtExpiration']) : DateTime.now();


    FantasyLeagueInvitation l = FantasyLeagueInvitation(
        email: email,
       );
    l.dtExpiration = dtExpiration;

    if (FantasyLeagueInvitationStatus.PENDING.statusCode == l.status
      && DateTime.now().isAfter(l.dtExpiration)){
      l.status = FantasyLeagueInvitationStatus.EXPIRED.statusCode;
    }else {
      l.status = status;
    }

    l.fantasyLeagueMongoId = fantasyLeagueMongoId;
    l.mongoId = mongoId;

    if (parsedJson['errorMsg'] != null) {
      String errorMsg = parsedJson['errorMsg'];
      l.errorMsg = errorMsg;
    }

    return l;
  }

  @override
  int compareTo(FantasyLeagueInvitation other) {
    if (mongoId == 'admin_invitation'){
      return -1;
    }

    if (other.mongoId == 'admin_invitation'){
      return 1;
    }

    if (status > other.status){
      return 1;
    }

    if (status < other.status){
      return -1;
    }

    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "invitedEmail": email,
      "invitingMongoUserId": AppContext.user.mongoUserId
    };
  }

  Map<String, dynamic> toJsonAccept() {
    return {
      "invitationMongoId": mongoId,
      "invitationUserMongoId": AppContext.user.mongoUserId
    };
  }

}
