import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'green': {
        'bgColor': Colors.green.shade50,
        'textColor': Colors.green,
      },
      'red': {
        'bgColor': Colors.red.shade50,
        'textColor': Colors.red,
      }
    };

    return Container(
      decoration: BoxDecoration(
          color: Colors.green.shade50, borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(7),
      child: Text(
        '목표 체중: 55kg',
        style: TextStyle(
          color: Colors.green.shade400,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
