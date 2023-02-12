import 'package:flutter/material.dart';

void main() {
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // app layout
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('To-do List', style: TextStyle(color: Colors.blue),),
          ),
          body: Container(alignment: Alignment.center, color: Colors.grey,
            child: Row(children: [
              Container(alignment: Alignment.center,)
            ],) ,

          ),
        )
    );
}
}