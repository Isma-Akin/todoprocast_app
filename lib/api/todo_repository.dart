import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/todo_models.dart';

class TodoRepository {
  static const String baseUrl = 'http://localhost:8080';
  static const String createTodoUrl = '/todos';
  static const String getAllTodosUrl = '/todos';

  static Future<List<Todo>> getAllTodos() async {
    // First, check if there are todos in the local storage
    final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
    final List<Todo> todos = todosBox.values.toList();

    // If there are todos in the local storage, return them
    if (todos.isNotEmpty) {
      return todos;
    }

    // If there are no todos in the local storage, fetch from the backend
    final response = await http.get(Uri.parse(baseUrl + getAllTodosUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final todos = jsonResponse.map<Todo>((json) => Todo.fromJson(json)).toList();

      // Add fetched todos to the local storage
      todosBox.addAll(todos);

      return todos;
    } else {
      throw Exception('Failed to get todos.');
    }
  }

  static Future<Todo> createTodo(Todo todo) async {
    // Send todo to the backend if there is an internet connection
    try {
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
        final Todo todo = Todo.fromJson(todoJson);
        return todo;
      } else {
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (error) {
      // If there is no internet connection, save the todo with an unsynced flag
      todo.isSynced = false;
      final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
      final int id = await todosBox.add(todo);
      return todo;
    }
  }


  static Future<Todo> updateTodo(Todo todo) async {
    // Update todo in local storage
    final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
    await todosBox.put(todo.id, todo);

    // Update todo in backend if there is an internet connection
    try {
      final response = await http.put(
        Uri.parse(baseUrl + '/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'task': todo.task,
          'description': todo.description,
          'dateCreated': todo.dateCreated.toIso8601String(),
          'dueDate': todo.dueDate.toIso8601String(),
          'taskCompleted': todo.taskCompleted,
          'taskCancelled': todo.taskCancelled,
          'isFavourite': todo.isFavourite,
          'id': todo.id,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Todo.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to update todo.');
      }
    } catch (error) {
      print('Failed to update todo on backend: $error');
    }

    // Return the updated todo
    return todo;
  }

  static Future<void> deleteTodoById(int id) async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + '/todos/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete todo.');
      }

      final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
      await todosBox.delete(id);
    } catch (error) {
      final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
      await todosBox.put(id, Todo(
        id: id,
        isSynced: false,
        isTempId: false,
        task: '',
        description: '',
        dateCreated: DateTime.now(),
        dueDate: DateTime.now(),
        taskCompleted: false,
        taskCancelled: false,
        isFavourite: false,
        groupId: '',
        steps: [],
      ));
    }
  }

  static Future<void> deleteAllTodos() async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + '/todos'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete all todos.');
      }

      final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
      await todosBox.clear();
    } catch (error) {
      // Handle error if the backend is down
      final Box<Todo> todosBox = await Hive.openBox<Todo>('todos');
      for (int i = 0; i < todosBox.length; i++) {
        final todo = todosBox.getAt(i);
        if (todo != null) {
          todo.isSynced = false;
          await todosBox.put(todo.id, todo);
        }
      }
    }
  }
}

