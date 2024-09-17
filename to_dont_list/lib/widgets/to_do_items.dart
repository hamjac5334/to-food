import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';
import 'package:to_dont_list/objects/item.dart';

typedef ToDoListChangedCallback = Function(Classes item, bool completed);
typedef ToDoListRemovedCallback = Function(Classes item);



class ClassListItem extends StatefulWidget {
  ClassListItem(
      {required this.course,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(course));

  final Classes course;
  final bool completed;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  @override
  State<ClassListItem> createState() => _ClassListItemState();
}

class _ClassListItemState extends State<ClassListItem> {

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
        widget.onListChanged(widget.course, widget.completed);
      },
      onLongPress: widget.completed
          ? () {
              widget.onDeleteItem(widget.course);
            }
          : null,
      leading: ElevatedButton(
        onPressed: () {
            setState(() {
              widget.course.increment();
            });
            
        },
        style:ElevatedButton.styleFrom(backgroundColor: widget.course.color.rgbcolor),
        //change this from item.name to item.abbrev
        //child: Text(item.name),
        child: Text(widget.course.count.toString()),
      ),
      title: Text(
        //adjust this to driplay name instead of abbrev
        widget.course.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
