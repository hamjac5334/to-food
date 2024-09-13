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

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return widget.completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

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
        widget.onListChanged(widget.pitch, widget.completed);
      },
      onLongPress: widget.completed
          ? () {
              widget.onDeleteItem(widget.pitch);
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

