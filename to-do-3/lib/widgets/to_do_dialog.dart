import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';

typedef FoodListAddedCallback = Function(String value, FoodGroup food,
    double calorie, TextEditingController textController);

class FoodDialog extends StatefulWidget {
  const FoodDialog({
    super.key,
    required this.onListAdded,
  });

  final FoodListAddedCallback onListAdded;

  @override
  State<FoodDialog> createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _calorieController =
      TextEditingController(); // Controller for calorie input

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";
  FoodGroup? food;
  double? calories;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Food'),
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
            decoration: const InputDecoration(hintText: "Type food name"),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                calories = double.tryParse(value);
              });
            },
            controller: _calorieController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "Enter calories"),
          ),
          DropdownButton<FoodGroup>(
            value: food,
            onChanged: (FoodGroup? newValue) {
              setState(() {
                food = newValue!;
              });
            },
            items: FoodGroup.values.map((FoodGroup classType) {
              return DropdownMenuItem<FoodGroup>(
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
              widget.onListAdded(
                valueText,
                food ?? FoodGroup.vegetable,
                calories!,
                _inputController,
              );
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
