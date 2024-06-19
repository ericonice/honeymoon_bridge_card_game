class ScoreModel {
  int games = 0;
  int underCompleted = 0;
  int underCurrent = 0;
  int over = 0;

  ScoreModel();

  int get total => underCompleted + underCurrent + over; 

  bool get vulnerable => games > 0;
}