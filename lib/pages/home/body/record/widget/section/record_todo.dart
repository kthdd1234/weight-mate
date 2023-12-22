import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/todo_container.dart';

class RecordTodo extends StatelessWidget {
  const RecordTodo({super.key});

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoData = [
      TodoItem(color: 'teal', text: '식단', icon: Icons.local_dining),
      TodoItem(color: 'lightBlue', text: '운동', icon: Icons.fitness_center),
      TodoItem(color: 'brown', text: '생활', icon: Icons.self_improvement),
    ];

    return Column(
      children: todoData
          .map(
            (item) => TodoContainer(
              color: item.color,
              text: item.text,
              icon: item.icon,
            ),
          )
          .toList(),
    );
  }
}

class TodoItem {
  TodoItem({required this.color, required this.text, required this.icon});
  String color, text;
  IconData icon;
}
