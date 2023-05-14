import 'package:flutter/material.dart';

import '../models/group_models.dart';
import '../widgets/todo_item.dart';

class GroupPage extends StatelessWidget {
  final Group group;

  GroupPage({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: ListView.builder(
        itemCount: group.todos.length,
        itemBuilder: (context, index) {
          return TodoItem(todo: group.todos[index],
                          group: group.todos[index].group);
        },
      ),
    );
  }
}
