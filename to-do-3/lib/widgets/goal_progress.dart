import 'package:flutter/material.dart';

class CalorieProgressIndicator extends StatelessWidget {
  final double current;
  final double goal;

  const CalorieProgressIndicator({
    required this.current,
    required this.goal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / goal;
    final isOverGoal = current > goal;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            isOverGoal ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isOverGoal 
              ? 'Over by ${(current - goal).toStringAsFixed(1)} calories'
              : '${(goal - current).toStringAsFixed(1)} calories remaining',
          style: TextStyle(
            color: isOverGoal ? Colors.red : Colors.green,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
