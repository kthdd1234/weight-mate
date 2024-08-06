import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/record/edit/container/todo_container.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

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
          svg: data.svg,
          type: type,
        ),
      ),
    );

    return Column(children: children);
  }
}
