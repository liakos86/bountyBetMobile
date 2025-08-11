
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:intl/intl.dart';

import '../enums/FantasyLeagueStatus.dart';
import 'FantasyLeagueInvitation.dart';
import 'User.dart';
import 'context/AppContext.dart';
import 'package:collection/collection.dart';



class FantasyLeague implements Comparable<FantasyLeague>{

  FantasyLeague({
    required this.name,
    required this.dtStart,
    required this.dtEnd,
    required this.selectedLeagueIds,
    required this.creatorUserId,
    required this.status,
    required this.isInvitation,
    required this.startingBalance,
    required this.allowTopUp,
  });

  FantasyLeague.defLeague();

  double startingBalance = 0;

  bool allowTopUp = false;

  List<String> invitedEmails = <String>[];
  List<User> users = <User>[];

  List<FantasyLeagueInvitation> invitations = <FantasyLeagueInvitation>[];

  bool isInvitation = false;

  String name = Constants.empty;

  DateTime dtStart = DateTime.now();

  DateTime dtEnd = DateTime.now();

  List<int> selectedLeagueIds = <int>[];

  String creatorUserId = Constants.defMongoId;

  int status = FantasyLeagueStatus.PENDING.statusCode;

  String mongoId = Constants.defMongoId;
  String invitationMongoId = '';

  static Future<FantasyLeague> fromJson(Map<String, dynamic> parsedJson) async{

    String mongoId = parsedJson['mongoId'];

    String invitationMongoId = '';
    if (parsedJson['invitationMongoId'] != null) {
      invitationMongoId = parsedJson['invitationMongoId'];
    }
    String creatorUserId = parsedJson['creatorMongoUserId'];
    String name = parsedJson['name'];
    int status = parsedJson['status'] as int;
    List<int> supportedLeagues = List<int>.from(parsedJson['supportedLeagueIds']);

    List<String> invitedEmails = <String>[];
    if (parsedJson['invitedEmails'] != null) {
       invitedEmails = List<String>.from(
          parsedJson['invitedEmails']);
    }

    bool isInvitation = parsedJson['isInvitation'] as bool;
    bool allowTopUp = parsedJson['allowTopUp'] as bool;
    double startingBalance = parsedJson['startingBalance'] as double;

    DateFormat formatter = DateFormat("MMM d, yyyy, h:mm:ss a");
    DateTime dtStart = formatter.parse(parsedJson['dtStart']);
    DateTime dtEnd = formatter.parse(parsedJson['dtEnd']);

    FantasyLeague l = FantasyLeague(allowTopUp: allowTopUp, startingBalance: startingBalance, isInvitation: isInvitation, creatorUserId: creatorUserId, name: name, status: status, dtStart: dtStart, dtEnd: dtEnd, selectedLeagueIds: supportedLeagues);

    if (parsedJson['invitations'] != null){
      List<FantasyLeagueInvitation> invitations = <FantasyLeagueInvitation>[];
      for (Map<String, dynamic> inv in parsedJson['invitations']){
        FantasyLeagueInvitation invitation = await FantasyLeagueInvitation.fromJson(inv);
        invitations.add(invitation);
      }

      l.invitations = invitations;
    }

    if (parsedJson['users'] != null){
      List<User> users = <User>[];
      for (Map<String, dynamic> inv in parsedJson['users']){
        User user = await User.fromJson(inv);
        users.add(user);
      }

      l.users = users;
    }

    l.mongoId = mongoId;
    l.invitationMongoId = invitationMongoId;
    l.invitedEmails = invitedEmails;
    return l;
  }

  @override
  int compareTo(FantasyLeague other) {
    if (dtStart.isAfter(other.dtStart)){
      return 1;
    }

    return -1;
  }

  Map<String, dynamic> toJson() {
    return {
      "fantasyLeagueMongoId": mongoId,
      "creatorMongoUserId": AppContext.user.mongoUserId,
      "name": name,
      "dtStart": dtStart.toUtc().toIso8601String() + 'Z',
      "dtEnd": dtEnd.toUtc().toIso8601String() + 'Z',
      "supportedLeagueIds": selectedLeagueIds,
      "startingBalance": startingBalance,
      "allowTopUp": allowTopUp
    };
  }

  copyFrom(FantasyLeague other){
    this.mongoId = other.mongoId;
    this.invitationMongoId = other.invitationMongoId;
    this.invitedEmails.clear();
    this.invitedEmails.addAll(other.invitedEmails);
    this.name = other.name;
    this.dtStart = other.dtStart;
    this.dtEnd = other.dtEnd;
    this.selectedLeagueIds.clear();
    this.selectedLeagueIds.addAll(other.selectedLeagueIds);
    this.creatorUserId = other.creatorUserId;
    this.status = other.status;
    this.allowTopUp = other.allowTopUp;
    this.startingBalance = other.startingBalance;
    this.isInvitation = other.isInvitation;

    this.invitations.clear();
    this.invitations.addAll(other.invitations);


    for (User userIncoming in other.users){
      User? userExisting = users.firstWhereOrNull((element) => element.mongoUserId == userIncoming.mongoUserId);
      if (userExisting != null){
        userExisting.deepCopyFrom(userIncoming);
     }else{
        users.add(userIncoming);
      }
    }


  }

  FantasyLeague clone() {
    FantasyLeague clone = FantasyLeague(
      name: name,
      dtStart: dtStart,
      dtEnd: dtEnd,
      selectedLeagueIds: List<int>.from(selectedLeagueIds),
      creatorUserId: creatorUserId,
      status: status,
      isInvitation: isInvitation,
      startingBalance: startingBalance,
      allowTopUp: allowTopUp,
    );

    clone.mongoId = mongoId;

    return clone;
  }



}

