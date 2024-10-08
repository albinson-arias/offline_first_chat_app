enum DefaultBios {
  available('Available'),
  busy('Busy'),
  atSchool('At school'),
  atTheMovies('At the movies'),
  atWork('At work'),
  batteryLow('Battery about to die'),
  inAMeeting('In a meeting'),
  atTheGym('At the gym'),
  sleeping('Sleeping');

  const DefaultBios(this.title);
  final String title;
}
