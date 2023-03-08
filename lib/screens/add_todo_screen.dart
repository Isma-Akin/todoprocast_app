import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          Text("Add a new todo",
            style: TextStyle(
                fontSize: 24),),
          SizedBox(height: 10,),
          TextField(
            autocorrect: true,
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Enter a todo title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              ElevatedButton(
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
                      fontWeight: FontWeight.bold),))
            ],
          ),
        ],),
    );
  }
}