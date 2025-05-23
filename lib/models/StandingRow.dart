import 'Team.dart';

class StandingRow implements Comparable<StandingRow>{

  int position =0;

  int points =0;

  int home_points =0;

  int away_points =0;

  int wins_total=0;

  int losses_total=0;
  int draws_total=0;


  String goals_total='';


  Team team ;

  StandingRow({required this.team});

  @override
  operator == (other) =>
      other is StandingRow &&
          other.position == position ;

  @override
  int get hashCode => position * 37;

  @override
  int compareTo(StandingRow other) {
    if (this.position < other.position){
      return -1;
    }

    if (this.position > other.position){
      return 1;
    }

    return 0;
  }

}