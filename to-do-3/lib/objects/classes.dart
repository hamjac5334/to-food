import 'package:flutter/material.dart';

enum FoodGroup {
  vegetable(Colors.green),
  fruit(Color.fromARGB(255, 245, 121, 162)),
  protein(Color.fromARGB(255, 194, 6, 0)),
  dairy(Colors.lightBlue),
  carbs(Color.fromARGB(255, 255, 215, 16));

  const FoodGroup(this.rgbcolor);

  final Color rgbcolor;
}

enum ExerciseGroup {
  abs,
  cardio,
  back,
  legs,
  arms,
  chest
}

class Classes {
  Classes({required this.name, required this.color, required this.calorie});
  final String name;
  final FoodGroup color;
  double calorie;
  int count = 1;

  void increment() {
    count++;
  }
}

class Exercises{
  Exercises({required this.name, required this.exname, required this.burned});
  final String name;
  final ExerciseGroup exname;
  double burned;
  int count = 1;

  void incrementex(){
    count++;
  }
}
