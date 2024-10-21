import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/pitch.dart';

typedef ToDoListChangedCallback = Function(Pitch item, bool completed);
typedef ToDoListRemovedCallback = Function(Pitch item);


class PitchCountItem extends StatefulWidget {
  PitchCountItem(
      {required this.pitch,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(pitch));

  final Pitch pitch;
  final bool completed;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  @override
  State<PitchCountItem> createState() => _PitchCountItemState();
}

class _PitchCountItemState extends State<PitchCountItem> {

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
        onPressed:(){
          setState(() {
            widget.pitch.increase();
          });
        },
        child: Text(widget.pitch.count.toString()),
      ),
      title: Text(
        widget.pitch.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

