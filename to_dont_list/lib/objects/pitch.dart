class Pitch {
  Pitch({required this.name});
  final String name;
  int count = 0;

  void increase(){
    count++;
  }

  void decrease() {
    if (count > 0) {
      count--;
    }
  }
}