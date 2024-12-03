import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/exercise_dialog.dart';
import 'package:to_dont_list/widgets/exercise_items.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';
import 'package:to_dont_list/widgets/goal_progress.dart';

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

  late double total;


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

  String _gettotal(){

    var exvalue = 0.0;
    for (double element in exerciseGroupCalories.values) {
    exvalue = combine(exvalue, element);
        }
    
    var value = 0.0;
    for (double element in foodGroupCalories.values) {
    value = combine(value, element);
        }

     total = (value - exvalue);   
      return (total.toString());
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
  void _showGoalDialog() {
  final TextEditingController goalController = TextEditingController(
    text: _calorieGoal.toString(),
  );

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Set Daily Calorie Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Calorie Goal',
                hintText: 'Enter your daily calorie goal',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newGoal = double.tryParse(goalController.text);
              if (newGoal != null && newGoal > 0) {
                setState(() {
                  _calorieGoal = newGoal;
                  _hasSetGoal = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
  double _calorieGoal = 2000.0; // Default daily calorie goal
  bool _hasSetGoal = false;
  double get _remainingCalories => _calorieGoal - double.parse(_gettotal());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     appBar: AppBar(
      title: const Text('Calorie List'),
      actions: [
        IconButton(
          icon: const Icon(Icons.flag),
          onPressed: _showGoalDialog,
          tooltip: 'Set Goal',
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Daily Goal: ${_calorieGoal.toStringAsFixed(1)}"),
            Text("Remaining: ${_remainingCalories.toStringAsFixed(1)}"),
          ],
        ),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CalorieProgressIndicator(
                current: double.parse(_gettotal()),
                goal: _calorieGoal,
              ),
              TabBar(
                labelColor: Colors.black,
                controller: _tabController,
                labelStyle: TextStyle(fontSize: 12.0),
                tabs: const [
                  Tab(text: "Food"),
                  Tab(text: "Exercises"),
                ],
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ],
          ),
        ),
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
  
  double combine(double value, double element) {
    double result = value + element;
    return result;
  }
}




void main() {
  runApp(const MaterialApp(
    title: 'Food List',
    home: FoodList(),
  ));
}
