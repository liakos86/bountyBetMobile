enum FantasyLeagueInvitationStatus{

  PENDING(statusCode: 1, text: 'Pending'),


  COMPLETED(statusCode: 2, text: 'Accepted'),


   EXPIRED(statusCode: 3, text: 'Expired');

  final int statusCode;
  final String text;

  const FantasyLeagueInvitationStatus({
    required this.statusCode,
    required this.text
  })  ;

  static FantasyLeagueInvitationStatus ofStatus(int code){
    for (FantasyLeagueInvitationStatus status in FantasyLeagueInvitationStatus.values){
      if (code == status.statusCode){
        return status;
      }
    }

    return FantasyLeagueInvitationStatus.PENDING;
  }

}