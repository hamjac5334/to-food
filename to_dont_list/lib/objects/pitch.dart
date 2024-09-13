class Pitch {
  Pitch({required this.strike});
  final bool strike;
  int count = 1;

  void increase(){
    count++;
  }
}