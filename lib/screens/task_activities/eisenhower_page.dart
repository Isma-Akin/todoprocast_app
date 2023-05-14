import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/models/models.dart';

class EisenhowerPage extends StatelessWidget {
  final List<Todo> todos;

  EisenhowerPage({required this.todos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eisenhower Matrix', style: GoogleFonts.openSans(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildQuadrant(
            context,
            'Important and Urgent',
            todos.where((todo) => todo.isImportant && todo.isUrgent).toList(),
          ),
          _buildQuadrant(
            context,
            'Important but Not Urgent',
            todos.where((todo) => todo.isImportant && !todo.isUrgent).toList(),
          ),
          _buildQuadrant(
            context,
            'Urgent but Not Important',
            todos.where((todo) => !todo.isImportant && todo.isUrgent).toList(),
          ),
          _buildQuadrant(
            context,
            'Not Important and Not Urgent',
            todos.where((todo) => !todo.isImportant && !todo.isUrgent).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuadrant(BuildContext context, String title, List<Todo> todos) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              // TODO: Implement reorder logic here
            },
            children: todos.map((todo) {
              return ListTile(
                key: Key(todo.id.toString()),
                title: Text(todo.task),
                leading: Checkbox(
                  value: todo.taskCompleted,
                  onChanged: (value) {
                    // TODO: Implement checkbox logic here
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
