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
                        dateCreated: DateTime.now());
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