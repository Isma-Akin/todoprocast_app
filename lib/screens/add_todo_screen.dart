import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';

import '../blocs/todos/todos_bloc.dart';
import '../models/todo_models.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();
    TextEditingController idController = TextEditingController();

    List<Todo> defaultTodos = [
      Todo(
        dateCreated: DateTime.now(),
        task: 'Buy groceries',
        description: 'Task description',
        id: '99',
        dueDate: DateTime.now().add(Duration(days: 1)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Study for exams',
        description: 'Task description',
        id: '98',
        dueDate: DateTime.now().add(Duration(days: 5)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Do laundry',
        description: 'Task description',
        id: '98',
        dueDate: DateTime.now().add(Duration(days: 2)),
      ),Todo(
        dateCreated: DateTime.now(),
        task: 'Meal prep',
        description: 'Task description',
        id: '97',
        dueDate: DateTime.now().add(Duration(days: 3)),
      // ),Todo(
      //   dateCreated: DateTime.now(),
      //   task: 'Clean room',
      //   description: 'Task description',
      //   id: '81',
      //   dueDate: DateTime.now().add(Duration(days: 3)),
      // ),Todo(
      //   dateCreated: DateTime.now(),
      //   task: 'Wash clothes',
      //   description: 'Task description',
      //   id: '82',
      //   dueDate: DateTime.now().add(Duration(days: 3)),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Add a new task",
            style: TextStyle(
                fontSize: 24),),
          SizedBox(height: 10,),
          TextField(
            autocorrect: true,
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Enter a task name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      Container(
        height: 75.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: defaultTodos.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                context.read<TodosBloc>().add(AddTodo(todo: defaultTodos[index]));
              },
              child: Card(
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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(style: TextButton.styleFrom(primary: AppColors.secondaryColor),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(fontSize: 20),)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppColors.tertiaryColor),
                  onPressed: (){
                    var todo = Todo(
                        id: idController.text,
                        task: taskController.text,
                        description: "description",
                        dateCreated: DateTime.now(),
                        dueDate: DateTime.now());
                    context.read<TodosBloc>().add(AddTodo(todo: todo));
                    Navigator.pop(context);
                  },
                  child: Text("Add Todo",
                    style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold),))
            ],
          ),
        ],),
    );
  }
}