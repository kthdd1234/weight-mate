import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/todo_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

List<TodoItem> todoData = [
  TodoItem(
    id: FILITER.diet.toString(),
    color: 'teal',
    title: '식단',
    icon: Icons.local_dining,
  ),
  TodoItem(
    id: FILITER.exercise.toString(),
    color: 'lightBlue',
    title: '운동',
    icon: Icons.fitness_center,
  ),
  TodoItem(
    id: FILITER.lifeStyle.toString(),
    color: 'brown',
    title: '생활',
    icon: Icons.self_improvement,
  ),
];

class RecordTodo extends StatelessWidget {
  const RecordTodo({super.key});

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;

    return Column(
      children: todoData.map(
        (item) {
          if (filterList == null) {
            return const EmptyArea();
          }

          return filterList.contains(item.id)
              ? Column(
                  children: [
                    SpaceHeight(height: tinySpace),
                    TodoContainer(
                      containerId: item.id,
                      color: item.color,
                      title: item.title,
                      icon: item.icon,
                    ),
                    SpaceHeight(height: smallSpace),
                  ],
                )
              : const EmptyArea();
        },
      ).toList(),
    );
  }
}

class TodoItem {
  TodoItem({
    required this.id,
    required this.color,
    required this.title,
    required this.icon,
  });

  dynamic id;
  String color, title;
  IconData icon;
}
