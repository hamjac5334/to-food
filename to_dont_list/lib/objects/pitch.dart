class Pitch {
  Pitch({required this.name});
  final String name;
  int count = 1;

  void increase(){
    count++;
  }
}