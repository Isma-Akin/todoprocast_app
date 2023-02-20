import 'package:flutter/material.dart';
import 'package:todoprocast_app/models/todo_models.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  
  const TodoDetailScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
