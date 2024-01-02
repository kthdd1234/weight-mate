import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/todo_container.dart';
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

List<TodoItem> todoData = [
  TodoItem(
    id: FILITER.diet.toString(),
    type: PlanTypeEnum.diet.toString(),
    color: 'teal',
    title: '식단',
    icon: Icons.local_dining,
  ),
  TodoItem(
    id: FILITER.exercise.toString(),
    type: PlanTypeEnum.exercise.toString(),
    color: 'lightBlue',
    title: '운동',
    icon: Icons.fitness_center,
  ),
  TodoItem(
    id: FILITER.lifeStyle.toString(),
    type: PlanTypeEnum.lifestyle.toString(),
    color: 'brown',
    title: '습관',
    icon: Icons.self_improvement,
  ),
];

class EditTodo extends StatelessWidget {
  EditTodo({
    super.key,
    required this.importDateTime,
    required this.recordType,
  });

  DateTime importDateTime;
  RECORD recordType;

  @override
  Widget build(BuildContext context) {
    bool isEdit = RECORD.edit == recordType;

    return isEdit
        ? Column(
            children: todoData
                .map((item) => TodoContainer(
                      containerId: item.id,
                      color: item.color,
                      title: item.title,
                      icon: item.icon,
                      type: item.type,
                      importDateTime: importDateTime,
                    ))
                .toList(),
          )
        : TodoResult(importDateTime: importDateTime);
  }
}
