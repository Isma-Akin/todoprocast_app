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
      body: BlocBuilder(
        builder: (context, state) {
          if (state is TodosInitial){
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

                ],

              ),),
            )
          }
        }),
      ),
    );
  }

  Column _inputField(
      String field,
      TextEditingController controller,
      ) {
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
        )
      ],
    ),
  }
}
