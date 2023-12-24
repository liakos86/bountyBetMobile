enum Sport{

  soccer(sportId: 1),

  basketBall(sportId: 2);

  final int sportId;

  const Sport({required this.sportId});

  static Sport ofId(int id){
    for (Sport sport in Sport.values){
      if (id == sport.sportId){
        return sport;
      }
    }

    return soccer;
  }

}