import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/models/todo_models.dart';

import '../blocs/todos/todos_bloc.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;
  
  const TodoDetailScreen({required this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {

  final List<bool> _steps = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details: ${widget.todo.task}',
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
            Text('Todo ID: ${widget.todo.id}',
            style: todotitle[0],
            ),
            const Divider(height: 8,),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              Icon(Icons.home)
            ],
            ),
            TextFormField(
              initialValue: widget.todo.task,
              decoration: InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<TodosBloc>().add(
                  UpdateTodo(todo: widget.todo));
              },
            ),
            const SizedBox(height: 20,
            ),
            TextFormField(
              initialValue: widget.todo.description,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<TodosBloc>().add(
                    UpdateTodo(todo: widget.todo));
              },
            ),
            const SizedBox(height: 20,
            ),
            Text('Date Created: ${widget.todo.dateCreated}',
            style: todotitle[1],
            ),
            const SizedBox(height: 20,
            ),
            Switch(value: widget.todo.taskCompleted ?? false,
                focusColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
                activeColor: Colors.green,
                onChanged: (newValue) {
              context.read<TodosBloc>().add(
                UpdateTodo(
                todo: widget.todo.copyWith(taskCompleted: newValue),
              ),);
                }),
            Text('Completed: ${'Yes or no'}',
            style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 50,),
            Text("Steps", style: todotitle[0],),
            Row(children: [Text("Step 1", style: todotitle[1],),
              Checkbox(value: _steps[0], onChanged: (value) {
                setState(() {
                  _steps[0] = value!;
                });
              },
              ),
            ],),
            Row(children: [Text("Step 2", style: todotitle[1],),
              Checkbox(value: _steps[1], onChanged: (value) {
                setState(() {
                  _steps[1] = value!;
                });
              },
              ),
            ],),
            Row(children: [Text("Step 3", style: todotitle[1],),
              Checkbox(value: _steps[2], onChanged: (value) {
                setState(() {
                  _steps[2] = value!;
                });
              },
              ),
            ],),
            Row(children: [Text("Step 4", style: todotitle[1],),
              Checkbox(value: _steps[3], onChanged: (value) {
                setState(() {
                  _steps[3] = value!;
                });
              },
              ),
            ],),
            
          ],
        ),
      ),
    );
  }
}
