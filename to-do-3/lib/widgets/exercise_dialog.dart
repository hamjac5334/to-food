import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';

typedef ExerciseListAddedCallback = Function(String value, ExerciseGroup exercise,
    double burned, TextEditingController textController);

class ExerciseDialog extends StatefulWidget {
  const ExerciseDialog({
    super.key,
    required this.onListAdded,
  });

  final ExerciseListAddedCallback onListAdded;

  @override
  State<ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _burnedController =
      TextEditingController(); // Controller for calorie input

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";
  double? calories;
  ExerciseGroup? exercise;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add an Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _inputController,
            decoration: const InputDecoration(hintText: "Type Exercise name"),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                calories = double.tryParse(value);
              });
            },
            controller: _burnedController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "Enter calories burned"),
          ),
          DropdownButton<ExerciseGroup>(
            value: exercise,
            onChanged: (ExerciseGroup? newValue) {
              setState(() {
                exercise = newValue!;
              });
            },
            items: ExerciseGroup.values.map((ExerciseGroup classType) {
              return DropdownMenuItem<ExerciseGroup>(
                value: classType,
                child: Text(classType.name),
              );
            }).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          key: const Key("OKButton"),
          style: yesStyle,
          child: const Text('OK'),
          onPressed: () {
            if (calories != null) {
              widget.onListAdded(valueText,
                exercise ?? ExerciseGroup.cardio,
                 calories!,
                _inputController,);
              Navigator.pop(context);
            }
          },
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _inputController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("CancelButton"),
              style: noStyle,
              onPressed: value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Cancel'),
            );
          },
        ),
      ],
    );
  }
}
