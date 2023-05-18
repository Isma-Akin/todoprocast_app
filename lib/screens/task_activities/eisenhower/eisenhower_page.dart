import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/models/models.dart';

import '../../../blocs/todos/todos_bloc.dart';
import '../../../blocs/todos_status/todos_status_bloc.dart';

class EisenhowerPage extends StatefulWidget {
  const EisenhowerPage({Key? key}) : super(key: key);

  @override
  _EisenhowerPageState createState() => _EisenhowerPageState();
}

class _EisenhowerPageState extends State<EisenhowerPage> {
  late List<Todo> todos;


  @override
  void initState() {
    super.initState();
    todos = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.cover,
              image: const AssetImage('assets/images/cloudbackground.jpg'),
            ),
          )
        ),
        title: Text('Eisenhower Matrix',
          style: GoogleFonts.openSans(
              fontSize: 25),),
        centerTitle: true,
      ),
      body: BlocBuilder<TodosStatusBloc, TodosStatusState>(
        builder: (context, state) {
          if (state is TodosStatusLoaded) {
            todos = state.pendingTodos;

            return Column(
              children: [
                DropdownButton<Todo>(
                  items: todos.map((Todo todo) {
                    return DropdownMenuItem<Todo>(
                      value: todo,
                      child: Text(todo.task),
                    );
                  }).toList(),
                  onChanged: (Todo? todo) {
                    if (todo != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Select Quadrant'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Important and Urgent'),
                                  onTap: () {
                                    todo.isImportant = true;
                                    todo.isUrgent = true;
                                    context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('Important but Not Urgent'),
                                  onTap: () {
                                    todo.isImportant = true;
                                    todo.isUrgent = false;
                                    context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('Urgent but Not Important'),
                                  onTap: () {
                                    todo.isImportant = false;
                                    todo.isUrgent = true;
                                    context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('Not Important and Not Urgent'),
                                  onTap: () {
                                    todo.isImportant = false;
                                    todo.isUrgent = false;
                                    context.read<TodosBloc>().add(UpdateTodo(todo: todo));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      _buildQuadrant(
                        context,
                        'Important and Urgent',
                        todos.where((todo) => todo.isImportant && todo.isUrgent).toList(),
                      ),
                      _buildQuadrant(
                        context,
                        'Important but Not Urgent',
                        todos.where((todo) => todo.isImportant && !todo.isUrgent).toList(),
                      ),
                      _buildQuadrant(
                        context,
                        'Urgent but Not Important',
                        todos.where((todo) => !todo.isImportant && todo.isUrgent).toList(),
                      ),
                      _buildQuadrant(
                        context,
                        'Not Important and Not Urgent',
                        todos.where((todo) => !todo.isImportant && !todo.isUrgent).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Handle other states
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildQuadrant(BuildContext context, String title, List<Todo> todos) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
        ),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final Todo item = todos.removeAt(oldIndex);
                todos.insert(newIndex, item);
              });
            },
            children: todos.map((todo) {
              return ListTile(
                key: Key(todo.id.toString()),
                title: Text(todo.task),
                leading: Checkbox(
                  value: todo.taskCompleted,
                  onChanged: (value) {
                    setState(() {
                      todo.taskCompleted = value ?? false;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
