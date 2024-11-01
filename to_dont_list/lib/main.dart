// Started with https://docs.flutter.dev/development/ui/widgets-intro


import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/pitch.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';

//imported for random color generation (Jack Hamilton)
import 'dart:math';

class PitchCount extends StatefulWidget {
  const PitchCount({super.key});

  @override
  State createState() => _PitchCountState();
}

class _PitchCountState extends State<PitchCount> {
  
  final Random _random = Random();
  //adjusted Sam's original list of just Pitch to different types of pitches
  final List<Pitch> items = [Pitch(name: "Pitch"), Pitch(name: "Curveball"),Pitch(name: "Fastball"), Pitch(name: "Slider"), Pitch(name: "Changeup")];
  final _itemSet = <Pitch>{};
  final Map<String, Color> pitchColors = {
    "Pitch": Colors.blue,
    "Curveball": Colors.green,
    "Fastball": Colors.red,
    "Slider": Colors.purple,
    "Changeup": Colors.orange,
  };


  void _handleListChanged(Pitch item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Pitch item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
      pitchColors.remove(item.name);
    });
  }

  void _handleNewItem(String itemText, TextEditingController textController) {
    setState(() {
      print("Adding new item");
      Pitch item = Pitch(name: itemText);
      items.insert(0, item);
      textController.clear();
      //add here
      final Color randomColor = _getRandomColor();
      pitchColors[itemText] = randomColor;
    });
  }

//https://stackoverflow.com/questions/51340588/flutter-how-can-i-make-a-random-color-generator-background (Jack Hamilton)
  Color _getRandomColor() {
    return Color.fromARGB(
      255, _random.nextInt(256), _random.nextInt(256), _random.nextInt(256), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pitch Tracker'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return PitchCountItem(
              pitch: item,
              completed: _itemSet.contains(item),
              color: pitchColors[item.name] ?? _getRandomColor(),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
            
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToDoDialog(onListAdded: _handleNewItem);
                  });
            }));
  }
}



void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: PitchCount(),
  ));
}
