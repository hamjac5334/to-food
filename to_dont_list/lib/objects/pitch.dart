class Pitch {
  Pitch({required this.name});
  final String name;
  int count = 0;

  void increase(){
    count++;
  }
}