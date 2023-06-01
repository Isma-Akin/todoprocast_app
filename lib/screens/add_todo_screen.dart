import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/constants.dart';

import '../blocs/todos/todos_bloc.dart';
import '../models/sharedpreferences_helper.dart';
import '../models/todo_models.dart';

class AddTodoScreen extends StatefulWidget {
  final TodosBloc todosBloc;
  final bool isFromFavouritesScreen;
  const AddTodoScreen({
    Key? key, required this.todosBloc, required this.isFromFavouritesScreen,
  }) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}
class _AddTodoScreenState extends State<AddTodoScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    List<Todo> defaultTodos = [
      Todo(
        deadline: DateTime.now().add(const Duration(days: 1)),
        dateCreated: DateTime.now(),
        id: 1,
        task: 'Buy groceries',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        steps: [],
      ),
      Todo(
        deadline: DateTime.now().add(const Duration(days: 2)),
        dateCreated: DateTime.now(),
        task: 'Study for exams',
        id: 2,
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 5)),
      ),
      Todo(
        dateCreated: DateTime.now(),
        task: 'Do laundry',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 2)), id: 6000,
        deadline: DateTime.now().add(const Duration(days: 5)),
      ),
      Todo(
        dateCreated: DateTime.now(),
        task: 'Meal prep',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        id: 6002,
        deadline: DateTime.now().add(const Duration(days: 4)),
      ),
      Todo(
        dateCreated: DateTime.now(),
        task: 'Vacuum',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        deadline: DateTime.now().add(const Duration(days: 2)),
        id: 6003,
      ),
      Todo(
        dateCreated: DateTime.now(),
        task: 'Replace light-bulbs',
        description: '',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        deadline: DateTime.now().add(const Duration(days: 3)),
        id: 6004,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
          child: TextField(
          onSubmitted: (value) async {
              // gets the last used id and increment it to generate a new id
              final lastUsedId = await SharedPreferencesHelper.getLastUsedId();
              final newId = lastUsedId + 1;
              // save the new id as the last used id
              await SharedPreferencesHelper.saveLastUsedId(newId);
              var todo = Todo(
              deadline: DateTime.now().add(const Duration(days: 3)),
              task: taskController.text,
              description: " ",
              dateCreated: DateTime.now(),
              dueDate: DateTime.now().add(Duration(days: 10)),
              taskCompleted: false,
              taskCancelled: false,
              isFavourite: widget.isFromFavouritesScreen ? true : false,
              id: newId,
              );
              context.read<TodosBloc>().add(AddTodo(todo: todo));
              BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
              taskController.clear();
              Navigator.pop(context);
              },
                textInputAction: TextInputAction.done,
                  style: GoogleFonts.openSans(
                      fontSize: 20),
                  controller: taskController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Add a task',
                    labelStyle: TextStyle(color: AppColors.blueTertiaryColor),
                    prefixIcon: Icon(Icons.add,
                      color: AppColors.blueSecondaryColor,),
                    border: InputBorder.none,
                    // hintText: "Add mini task",
                  ),
                ),
              ),
              // SizedBox(
              //   height: 50,
              //   width: 50,
              //   child: IconButton(
              //     onPressed: () async {
              //       var todo = Todo(
              //         task: taskController.text,
              //         description: " ",
              //         dateCreated: DateTime.now(),
              //         dueDate: null,
              //         taskCompleted: false,
              //         taskCancelled: false,
              //         isFavourite: false,
              //         id: 7,
              //       );
              //       context.read<TodosBloc>().add(AddTodo(todo: todo));
              //       BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
              //       taskController.clear();
              //       Navigator.pop(context);
              //     },
              //     icon: const Icon(Icons.control_point_rounded,
              //         color: AppColors.blueSecondaryColor,
              //         size: 40,),
              //   ),
              // ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
    // const SizedBox(height: 10,),
        const Divider(thickness: 1,color: Colors.grey),
    SizedBox(
      height: 45.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: defaultTodos.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              // gets the last used id and increment it to generate a new id
              final lastUsedId = await SharedPreferencesHelper.getLastUsedId();
              final newId = lastUsedId + 1;
              // save the new id as the last used id
              await SharedPreferencesHelper.saveLastUsedId(newId);
              context.read<TodosBloc>().add(AddTodo(todo: defaultTodos[index]));
              BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
            },
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(defaultTodos[index].task),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
        const SizedBox(height: 10,),
      ],);
  }
}