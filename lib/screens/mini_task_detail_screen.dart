import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:todoprocast_app/constants.dart';

class MiniTaskDetailScreen extends StatefulWidget {
  final String taskTitle;

  const MiniTaskDetailScreen({Key? key, task, required this.taskTitle}) : super(key: key);

  @override
  State<MiniTaskDetailScreen> createState() => _MiniTaskDetailScreenState();
}

class _MiniTaskDetailScreenState extends State<MiniTaskDetailScreen> {
  final List<String> _tasks = [];

  final TextEditingController _textEditingController = TextEditingController();

  void _addTask() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_textEditingController.text);
        _textEditingController.clear();
      });
    }
  }

  void _markTaskAsDone(int index) {
    setState(() {
      _tasks[index] = '${_tasks[index]} (Done)';
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Mini Task Detail Screen'),
        backgroundColor: AppColors.blueTertiaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cloudbackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Text(widget.taskTitle, style: const TextStyle(fontSize: 45)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter task name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: AppColors.blueSecondaryColor,
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: ListTile(
                        title: Text(_tasks[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _markTaskAsDone(index),
                              icon: const Icon(Icons.done),
                            ),
                            IconButton(
                              onPressed: () => _deleteTask(index),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
