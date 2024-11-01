import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/pitch.dart';

typedef ToDoListChangedCallback = Function(Pitch item, bool completed);
typedef ToDoListRemovedCallback = Function(Pitch item);


class PitchCountItem extends StatefulWidget {
  PitchCountItem(
      {required this.pitch,
      required this.completed,
      required this.color,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(pitch));

  final Pitch pitch;
  final bool completed;
  final Color color;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  @override
  State<PitchCountItem> createState() => _PitchCountItemState();
}

class _PitchCountItemState extends State<PitchCountItem> {

  /*final Map<String, Color> pitchColors = {
    "Pitch": Colors.blue,
    "Curveball": Colors.green,
    "Fastball": Colors.red,
    "Slider": Colors.purple,
    "Changeup": Colors.orange,
  };*/

  TextStyle? _getTextStyle(BuildContext context) {
    if (!widget.completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          widget.pitch.increase();
        });
      },
      onLongPress: widget.completed
          ? () {
            }
          : null,
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
        ),
        onPressed:(){
          setState(() {
            widget.pitch.increase();
          });
        },
        //changed textcolor to white to see better after I added background color
        child: Text(widget.pitch.count.toString(), style: const TextStyle(color: Colors.white),),
      ),
      title: Text(
        widget.pitch.name,
        style: _getTextStyle(context),
      ),

      //added + and minus icons here
      //
      //gets the icons on the right (trailing) side
      //https://stackoverflow.com/questions/54548853/placing-two-trailing-icons-in-listtile
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //I watched this tutorial of making a calculator to see how they layed out the buttons
          //https://www.youtube.com/watch?app=desktop&v=_DHNmRaUZgM
          IconButton(
            icon: const Icon(Icons.remove),
            color: Colors.black,
            onPressed: () {
              setState(() {
                widget.pitch.decrease();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              setState(() {
                widget.pitch.increase();
              });
            },
          ),
        ],
      ),
    );
  }
}

