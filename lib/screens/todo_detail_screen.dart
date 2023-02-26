import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/models/todo_models.dart';

import '../blocs/todos/todos_bloc.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  
  const TodoDetailScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details: ${todo.task}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todo ID: ${todo.id}',
            style: Theme.of(context).textTheme.headline6,
            ),
            const Divider(height: 8,),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              Icon(Icons.home)
            ],
            ),
            Text('Task: ${todo.task}',
            style: Theme.of(context).textTheme.subtitle1
            ),
            const SizedBox(height: 20,
            ),
            Text('Description: ${todo.description}',
            style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20,
            ),
            Switch(value: todo.taskCompleted ?? false,
                focusColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
                activeColor: Colors.green,
                onChanged: (newValue) {
              context.read<TodosBloc>().add(
                UpdateTodo(
                todo: todo.copyWith(taskCompleted: newValue),
              ),);
                }),
            Text('Completed: ${'Yes or no'}',
            style: Theme.of(context).textTheme.subtitle2,)
          ],
        ),
      ),
    );
  }
}
