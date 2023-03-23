import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:intl/intl.dart';

import '../blocs/todos/todos_bloc.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;
  
  const TodoDetailScreen({required this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.todo.taskCompleted ?? false;
  }
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  String formattedDueDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

  // final List<bool> _steps = [false, false, false, false];
  final List<String> _newSteps = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _stepController = TextEditingController();

  void _showEditStepDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Step'),
          content: TextFormField(
            controller: TextEditingController(text: widget.todo.steps[index]),
            decoration: InputDecoration(
              labelText: 'Step ${index + 1}',
              border: OutlineInputBorder(),
            ),
            onSaved: (newValue) {
              setState(() {
                widget.todo.steps[index] = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a step';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                }
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => TodosBloc(),
  child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tertiaryColor,
        title: Text(widget.todo.task,
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
            Text(widget.todo.task,
            style: Theme.of(context).textTheme.headline4,
            ),
            const Divider(height: 8,),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Icon(Icons.title)
            ],
            ),
            // TextFormField(
            //   initialValue: widget.todo.task,
            //   decoration: InputDecoration(
            //     labelText: 'Task',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (value) {
            //     context.read<TodosBloc>().add(
            //       UpdateTodo(todo: widget.todo));
            //   },
            // ),
            // const SizedBox(height: 20,
            // ),
            // Row(mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Icon(Icons.description)
            //   ],
            // ),
            TextFormField(
              style: TextStyle(fontSize: 18),
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
            Text('Date Created: $formattedDate',
            style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20,
            ),
            Text('Due Date: $formattedDueDate',
            style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20,
            ),
            // Switch(
            //     value: widget.todo.taskCompleted ?? false,
            //     focusColor: Colors.blue,
            //     inactiveThumbColor: Colors.grey,
            //     activeColor: Colors.green,
            //     onChanged: (newValue) {
            //   context.read<TodosBloc>().add(
            //     UpdateTodo(
            //     todo: widget.todo.copyWith(taskCompleted: newValue),
            //   ),);
            //     }),

            Row(
              children: [
                Text("Mark as complete", style: Theme.of(context).textTheme.titleMedium,),
                Checkbox(
                    value: widget.todo.taskCompleted ?? false,
                    onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                    context.read<TodosBloc>().add(UpdateTodo(
                    todo: widget.todo.copyWith(taskCompleted: newValue),
      )
    );
    }
    ),
              ],
            ),
            const SizedBox(height: 50,),
            Text("Steps", style: Theme.of(context).textTheme.headlineMedium,),
        Expanded(
            child: BlocBuilder<TodosBloc, TodosState>(
            builder: (context, state) {
          return ListView.builder(
              itemCount: widget.todo.steps.length + _newSteps.length,
                itemBuilder: (context, index) {
                if (index < widget.todo.steps.length) {
          return Row(
            children: [
              Text("Step ${index + 1}"),
              SizedBox(width: 10,),
              Expanded(
                child:
                Text(widget.todo.steps[index], style: TextStyle(fontSize: 18),),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                  onPressed: () {
                  _showEditStepDialog(context, index);
                  },
                  ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                setState(() {
                  widget.todo.steps.removeAt(index);
                    });
                  },
                ),
              ],
            );
          } else {
                  final stepIndex = index - widget.todo.steps.length;
                  return Row(
                    children: [
                      Text("Step ${index + 1}"),
                      SizedBox(width: 10,),
                      Expanded(
                        child:
                        Text(_newSteps[stepIndex], style: TextStyle(fontSize: 18),),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditStepDialog(context, index);
                        },
                      ),
                      IconButton(icon: Icon(Icons.delete),
                        onPressed: () {
                        setState(() {
                          _newSteps.removeAt(stepIndex);
                        });
                      },
                      ),
                    ],
                  );
    }});
  },
)),
            SizedBox(height: 20,),
            Form(key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stepController,
                        decoration: InputDecoration(
                          labelText: 'Add a step',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a step';
                          }
                          return null;
                        },
                      )
                    )
                  ]
                )),
            SizedBox(height: 0.5,),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: SizedBox(width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.tertiaryColor,
                  ),
                  child: Text('Add Step'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _newSteps.add(_stepController.text);
                        _stepController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
);
  }
}
