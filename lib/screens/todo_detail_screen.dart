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
  late final Todo todo;
  late final TodosBloc todosBloc;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    todo = widget.todo;
    _descriptionController = TextEditingController(text: widget.todo.description);
    todosBloc = context.read<TodosBloc>();
    _isChecked = widget.todo.taskCompleted ?? false;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _formKey.currentState?.save();
    super.dispose();
  }

  void _updateTodoDescription(String newDescription) {
    final updatedTodo = todo.copyWith(description: newDescription);
    todosBloc.add(UpdateTodo(todo: updatedTodo));
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
          title: const Text('Edit Step'),
          content: TextFormField(
            controller: TextEditingController(text: widget.todo.steps[index]),
            decoration: InputDecoration(
              labelText: 'Step ${index + 1}',
              border: const OutlineInputBorder(),
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
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                }
              },
              child: const Text('SAVE'),
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
            style: const TextStyle(
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
              children: const [
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
              onSaved: (value) {
      final updatedTodo = widget.todo.copyWith(description: value);
      context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
      },
              controller: _descriptionController,
              style: const TextStyle(fontSize: 18),
              // initialValue: widget.todo.description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: _updateTodoDescription,
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
              const SizedBox(width: 10,),
              Expanded(
                child:
                Text(widget.todo.steps[index], style: const TextStyle(fontSize: 18),),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                  onPressed: () {
                  _showEditStepDialog(context, index);
                  },
                  ),
              IconButton(
                icon: const Icon(Icons.delete),
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
                      const SizedBox(width: 10,),
                      Expanded(
                        child:
                        Text(_newSteps[stepIndex], style: const TextStyle(fontSize: 18),),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditStepDialog(context, index);
                        },
                      ),
                      IconButton(icon: const Icon(Icons.delete),
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
            const SizedBox(height: 20,),
            Form(key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stepController,
                        decoration: const InputDecoration(
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
            const SizedBox(height: 0.5,),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: SizedBox(width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.tertiaryColor,
                  ),
                  child: const Text('Add Step'),
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
