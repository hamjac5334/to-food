import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/classes.dart';
import 'package:to_dont_list/objects/item.dart';

typedef ExerciseListChangedCallback = Function(Exercises item, bool completed);
typedef ExerciseListRemovedCallback = Function(Exercises item);
typedef IncrementExerciseCallback = void Function(ExerciseGroup exerciseGroup);
typedef IncrementExerciseCalorieCallback = void Function(ExerciseGroup exerciseGroup,
     double calorie);

class ExerciseListItem extends StatefulWidget {
  ExerciseListItem(
      {required this.course,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.onIncrementExercise,
      required this.onIncrementExerciseCalorie})
      : super(key: ObjectKey(course));

  final Exercises course;
  final bool completed;

  final ExerciseListChangedCallback onListChanged;
  final ExerciseListRemovedCallback onDeleteItem;
  final IncrementExerciseCallback onIncrementExercise;
  final IncrementExerciseCalorieCallback onIncrementExerciseCalorie;

  @override
  State<ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
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
            widget.course.incrementex();

             widget.onIncrementExercise(widget.course.exname);

            //try adding change here
            widget.onIncrementExerciseCalorie(widget.course.exname,
                widget.course.burned);
          });
        },
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
