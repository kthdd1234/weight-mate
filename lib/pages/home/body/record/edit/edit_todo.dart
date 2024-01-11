import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class TodoItem {
  TodoItem({
    required this.id,
    required this.type,
    required this.color,
    required this.title,
    required this.icon,
  });

  dynamic id;
  String type;
  String color, title;
  IconData icon;
}

Map<String, TodoDataClass> todoData = {
  PlanTypeEnum.diet.toString(): TodoDataClass(
    filterId: FILITER.diet.toString(),
    color: 'teal',
    title: '식단',
    icon: Icons.local_dining,
  ),
  PlanTypeEnum.exercise.toString(): TodoDataClass(
    filterId: FILITER.exercise.toString(),
    color: 'lightBlue',
    title: '운동',
    icon: Icons.fitness_center,
  ),
  PlanTypeEnum.lifestyle.toString(): TodoDataClass(
    filterId: FILITER.lifeStyle.toString(),
    color: 'brown',
    title: '습관',
    icon: Icons.self_improvement,
  )
};

class EditTodo extends StatelessWidget {
  EditTodo({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    todoData.forEach(
      (type, data) => children.add(
        TodoContainer(
          filterId: data.filterId,
          color: data.color,
          title: data.title,
          icon: data.icon,
          type: type,
        ),
      ),
    );

    return Column(children: children);
  }
}

class TodoDataClass {
  TodoDataClass({
    required this.filterId,
    required this.color,
    required this.title,
    required this.icon,
  });

  String filterId;
  String color, title;
  IconData icon;
}
