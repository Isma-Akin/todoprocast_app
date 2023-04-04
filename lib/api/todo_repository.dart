import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/todo_models.dart';

class TodoRepository {
  static const String baseUrl = 'http://localhost:8080';
  static const String createTodoUrl = '/todos';
  static const String getAllTodosUrl = '/todos';

  static Future<List<Todo>> getAllTodos() async {
    final response = await http.get(Uri.parse(baseUrl + getAllTodosUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final todos = jsonResponse.map<Todo>((json) => Todo.fromJson(json)).toList();
      return todos;
    } else {
      throw Exception('Failed to get todos.');
    }
  }

  static Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl + createTodoUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'task': todo.task,
        'description': todo.description,
        'dateCreated': todo.dateCreated.toIso8601String(),
        'dueDate': todo.dueDate.toIso8601String(),
        'taskCompleted': todo.taskCompleted,
        'taskCancelled': todo.taskCancelled,
        'isFavourite': todo.isFavourite,
      }),
    );
    if (response.statusCode == 201) {
      final dynamic todoJson = json.decode(response.body);
      return Todo.fromJson(todoJson);
    } else {
      throw Exception('Failed to create todo: ${response.statusCode}');
    }
  }


  static Future<Todo> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse(baseUrl + '/todos/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Todo.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update todo.');
    }
  }

  static Future<void> deleteTodoById(int id) async {
    final response = await http.delete(Uri.parse(baseUrl + '/todos/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo.');
    }
  }
}

