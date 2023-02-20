import 'package:flutter/material.dart';
import 'package:todoprocast_app/models/todo_models.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  
  const TodoDetailScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todo ID: ${todo.id}',
            style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8,),
            Text('Task: ${todo.task}',
            style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8,
            ),
            Text('Description: ${todo.description}',
            style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 8,
            ),
            Text('Completed: ${'Yes or no'}',
            style: Theme.of(context).textTheme.subtitle2,)
          ],
        ),
      ),
    );
  }
}
