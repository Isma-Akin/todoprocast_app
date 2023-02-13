import 'package:flutter/material.dart';

void main() {
  runApp(const Todo());
}


class Todo extends StatefulWidget {
   const Todo({Key? key}) : super(key: key);
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  final tasks = ["Task 1", "Task 2", "Task 3", "Task 4"];
  final color = [Colors.blue, Colors.orange, Colors.green, Colors.purple];
  final taskdetails = ["Your first task", "Your second task", "Your third task", "Your fourth task"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Task list",
              style: TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 30,),
            ),
            leading: IconButton(
              tooltip: "Close",
              icon: const Icon(Icons.close_rounded),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            child: ListView.builder(
              itemCount: tasks.length,
            itemBuilder: (context, index){
                return SizedBox(
                  height: 100,
                  child: ListTile(
                    tileColor: color[index],
                    title: Text(tasks[index]),
                    subtitle: Text(taskdetails[index]),
                    leading: Icon(Icons.add_to_photos_rounded),
                    trailing: Icon(Icons.close),
                  ),
                );
            },),
          )

      ),
    );}
}

// Column(
// children: [
// Expanded(
// child: ListView(shrinkWrap: true,
// children: const [
// SizedBox(
// height: 100,
// child: ListTile(
// textColor: Colors.white,
// leading: Icon(Icons.library_books_sharp),
// title: Text("Task 1"), tileColor: Colors.purple,
// subtitle: Text("Your first task"),),
// ),
// Divider(),
// SizedBox(
// height: 100,
// child: ListTile(
// textColor: Colors.white,
// leading: Icon(Icons.library_books_sharp),
// title: Text("Task 2"), tileColor: Colors.blue,
// subtitle: Text("Your second task") ),
// ),
// Divider(),
// SizedBox(
// height: 100,
// child: ListTile(
// textColor: Colors.white,
// leading: Icon(Icons.library_books_sharp),
// title: Text("Task 3"), tileColor: Colors.green,
// subtitle: Text("Your third task"),),
// ),
// Divider(),
// SizedBox(
// height: 100,
// child: ListTile(
// textColor: Colors.white,
// leading: Icon(Icons.library_books_sharp),
// title: Text("Task 4"), tileColor: Colors.orange,
// subtitle: Text("Your fourth task"),),
// ),
// ],
// ))
// ],
// )