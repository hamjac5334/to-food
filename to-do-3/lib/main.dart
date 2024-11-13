import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';

class FoodList extends StatefulWidget {
  const FoodList({super.key});

  @override
  State createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  final List<Classes> items = [
    Classes(name: "Food", color: FoodGroup.vegetable, calorie: 150)
  ];
  final _itemSet = <Classes>{};

  // Add a final count for servings and calorie
  final Map<FoodGroup, int> foodGroupCounts = {
    for (var group in FoodGroup.values) group: 0
  };
  final Map<FoodGroup, double> foodGroupCalories = {
    for (var group in FoodGroup.values) group: 0.0
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servings Food List'),
      ),
      body: ListView(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: _showTotalDialog,
              child: const Text('Total'),
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return FoodDialog(onListAdded: _handleNewItem);
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
