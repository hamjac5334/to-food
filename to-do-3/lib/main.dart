import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/exercise_dialog.dart';
import 'package:to_dont_list/widgets/exercise_items.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';

class FoodList extends StatefulWidget {
  const FoodList({super.key});

  @override
  State createState() => _FoodListState();
}

class _FoodListState extends State<FoodList>  with TickerProviderStateMixin {
  final List<Classes> items = [
    Classes(name: "Food", color: FoodGroup.vegetable, calorie: 0)
  ];
  final _itemSet = <Classes>{};

   final List<Exercises> exercises = [
    Exercises(name: "Exercise", exname: ExerciseGroup.cardio, burned: 0)
  ];
  final _itemSet2 = <Exercises>{};


  // Add a final count for servings and calorie
  final Map<FoodGroup, int> foodGroupCounts = {
    for (var group in FoodGroup.values) group: 0
  };
  final Map<FoodGroup, double> foodGroupCalories = {
    for (var group in FoodGroup.values) group: 0.0
  };

 final Map<ExerciseGroup, int> exerciseGroupCounts = {
    for (var group in ExerciseGroup.values) group: 0
  };
  final Map<ExerciseGroup, double> exerciseGroupCalories = {
    for (var group in ExerciseGroup.values) group: 0.0
  };
 


  void _handleexListChanged(Exercises item, bool completed) {
    setState(() {
      exercises.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet2.add(item);
        exercises.add(item);
        exerciseGroupCounts[item.exname] =
          exerciseGroupCounts[item.exname]! + 1; // Update food group count
      exerciseGroupCalories[item.exname] = exerciseGroupCalories[item.exname]! +
          item.burned;
       // Add calories based on servings
      } else {
        print("Making Undone");
        _itemSet2.remove(item);
        exercises.insert(0, item);
        exerciseGroupCounts[item.exname] =
          exerciseGroupCounts[item.exname]! + 1; // Update food group count
      exerciseGroupCalories[item.exname] = exerciseGroupCalories[item.exname]! +
          item.burned;
       // Subtract calories based on servings
      }
    });
  }

  void _handleexDeleteItem(Exercises item) {
    setState(() {
      print("Deleting item");
      exercises.remove(item);
      exerciseGroupCounts[item.exname] =
          exerciseGroupCounts[item.exname]! - 1; // Update food group count
      exerciseGroupCalories[item.exname] = exerciseGroupCalories[item.exname]! -
          item.burned;

       // Adjust the calorie count when deleting
    });
  }

  void _handleexNewItem(String itemText, ExerciseGroup exercise, double calorie,
      TextEditingController textController) {
    setState(() {
      print("Adding new item");
      Exercises item = Exercises(name: itemText, exname: exercise, burned: calorie);
      exercises.insert(0, item);
      exerciseGroupCounts[exercise] =
          exerciseGroupCounts[exercise]! + 1; // Update food group count
      exerciseGroupCalories[exercise] = exerciseGroupCalories[exercise]! +
          item.burned;
      textController.clear(); // Clear the input field
    });
  }
   


  void _showexTotalDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Total Calories burned'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: exerciseGroupCounts.entries.map((entry) {
              final calories = exerciseGroupCalories[entry.key] ?? 0.0;
              return Text(
                  '${entry.key.name}: ${entry.value} reps, $calories calories');
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  

  void _handleListChanged(Classes item, bool completed) {
    setState(() {
      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
        foodGroupCounts[item.color] = foodGroupCounts[item.color]! + 1;
        foodGroupCalories[item.color] = foodGroupCalories[item.color]! +
            item.calorie; // Add calories based on servings
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
        foodGroupCounts[item.color] = foodGroupCounts[item.color]! - 1;
        foodGroupCalories[item.color] = foodGroupCalories[item.color]! -
            item.calorie; // Subtract calories based on servings
      }
    });
  }

  void _handleDeleteItem(Classes item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
      foodGroupCounts[item.color] = foodGroupCounts[item.color]! - 1;
      foodGroupCalories[item.color] = foodGroupCalories[item.color]! -
          item.calorie; // Adjust the calorie count when deleting
    });
  }

  void _handleNewItem(String itemText, FoodGroup food, double calorie,
      TextEditingController textController) {
    setState(() {
      print("Adding new item");
      Classes item = Classes(name: itemText, color: food, calorie: calorie);
      items.insert(0, item);
      foodGroupCounts[food] =
          foodGroupCounts[food]! + 1; // Update food group count
      foodGroupCalories[food] = foodGroupCalories[food]! +
          item.calorie; // Add calories based on servings
      textController.clear(); // Clear the input field
    });
  }

  
  void _incrementExerciseCount(ExerciseGroup exerciseGroup) {
    setState(() {
      exerciseGroupCounts[exerciseGroup] = exerciseGroupCounts[exerciseGroup]! + 1;
    });
  }

  void _incrementExerciseCalorie(ExerciseGroup exerciseGroup, double burned) {

    setState(() {
      exerciseGroupCalories[exerciseGroup] = exerciseGroupCalories[exerciseGroup]! + burned;
    });
  }


  void _incrementFoodGroupCount(FoodGroup foodGroup) {
    setState(() {
      foodGroupCounts[foodGroup] = foodGroupCounts[foodGroup]! + 1;
    });
  }

  void _incrementFoodGroupCalorie(FoodGroup foodGroup, double calorie) {
    setState(() {
      foodGroupCalories[foodGroup] = foodGroupCalories[foodGroup]! + calorie;
    });
  }

  void _showTotalDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Total Servings and Calories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: foodGroupCounts.entries.map((entry) {
              final calories = foodGroupCalories[entry.key] ?? 0.0;
              return Text(
                  '${entry.key.name}: ${entry.value} servings, $calories calories');
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

 late final TabController _tabController;
   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie List'),
        actions: [Text("Total Daily Calories:")],
        bottom: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 12.0),
          tabs: const [
            Tab(text: "Food"), // Wrap each Text in a Tab widget
            Tab(text: "Exercises"),
          ],
          indicatorSize: TabBarIndicatorSize
              .label, // Aligns the indicator with each label's width
          labelPadding: EdgeInsets.symmetric(
              horizontal: 16.0), // Optional: adjust spacing between tabs
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
         ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: items.map((item) {
          return ClassListItem(
            course: item,
            completed: _itemSet.contains(item),
            onListChanged: _handleListChanged,
            onDeleteItem: _handleDeleteItem,
            onIncrementFoodGroup: _incrementFoodGroupCount,
            onIncrementFoodGroupCalorie: _incrementFoodGroupCalorie,
          );
        }).toList(),
      ),
         ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: exercises.map((item) {
          return ExerciseListItem(
            course: item,
            completed: _itemSet.contains(item),
            onListChanged: _handleexListChanged,
            onDeleteItem: _handleexDeleteItem,
            onIncrementExercise: _incrementExerciseCount,
            onIncrementExerciseCalorie: _incrementExerciseCalorie,
          );
        }).toList(),),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: (){ if(_tabController.index == 0){
                      return _showTotalDialog();
                      }else{
                        return _showexTotalDialog();
                      }},
              child: const Text('Total'),
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      if(_tabController.index == 0){
                      return FoodDialog(onListAdded: _handleNewItem);
                      }else{
                        return ExerciseDialog(onListAdded: _handleexNewItem);
                      }
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}




void main() {
  runApp(const MaterialApp(
    title: 'Food List',
    home: FoodList(),
  ));
}
