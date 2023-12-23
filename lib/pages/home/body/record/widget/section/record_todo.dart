import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/todo_container.dart';

class RecordTodo extends StatelessWidget {
  const RecordTodo({super.key});

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoData = [
      TodoItem(color: 'teal', title: '식단', icon: Icons.local_dining),
      TodoItem(color: 'lightBlue', title: '운동', icon: Icons.fitness_center),
      TodoItem(color: 'brown', title: '생활', icon: Icons.self_improvement),
    ];

    return Column(
      children: todoData
          .map(
            (item) => TodoContainer(
              color: item.color,
              title: item.title,
              icon: item.icon,
            ),
          )
          .toList(),
    );
  }
}

class TodoItem {
  TodoItem({required this.color, required this.title, required this.icon});
  String color, title;
  IconData icon;
}
