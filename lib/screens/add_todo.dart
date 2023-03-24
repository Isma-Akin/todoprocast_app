import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/models.dart';
import '/blocs/blocs.dart';

class Add_ToDo extends StatefulWidget {
  const Add_ToDo({Key? key}) : super(key: key);

  @override
  State<Add_ToDo> createState() => _Add_ToDoState();
}

class _Add_ToDoState extends State<Add_ToDo> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add your todos"),
        backgroundColor: Colors.blueAccent,
        primary: true,
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TodosLoaded) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _inputField('ID', controllerId),
                    _inputField('Task', controllerTask),
                    _inputField('Description', controllerDescription),
                    ElevatedButton(
                      onPressed: () {
                        var todo = Todo(
                          id: controllerId.value.text,
                          task: controllerTask.value.text,
                          description: controllerDescription.value.text,
                          dateCreated: DateTime.now(),
                          dueDate: DateTime.now(),
                        );
                        context.read<TodosBloc>().add(AddTodo(todo: todo));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Theme
                              .of(context)
                              .primaryColor),
                      child: Text("Add todo"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Text("Something went wrong.");
          }
        },
      ),
    );
  }

  Column _inputField(
      String field,
      TextEditingController controller,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$field: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          child: TextFormField(
            controller: controller,
          ),
        )
      ],
    );
  }
}
