import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../models/sharedpreferences_helper.dart';
import '../models/todo_models.dart';

class TodoRepository {
  final SharedPreferences _prefs;
  TodoRepository({required SharedPreferences prefs}) : _prefs = prefs;

  static const String baseUrl = 'http://localhost:8080';
  static const String createTodoUrl = '/todos';
  static const String getAllTodosUrl = '/todos';

  static Future<List<Todo>> getAllTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + getAllTodosUrl));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final todos = jsonResponse.map<Todo>((json) => Todo.fromJson(json)).toList();
        await SharedPreferencesHelper.saveTodos(todos);
        return todos;
      } else {
        throw Exception('Failed to get todos.');
      }
    } catch (e) {
      print('Error: $e');
      final todos = await SharedPreferencesHelper.getTodos();
      return todos;
    }
  }


  static Future<Todo> createTodo(Todo todo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + createTodoUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'task': todo.task,
          'description': todo.description,
          'dateCreated': todo.dateCreated.toIso8601String(),
          'dueDate': todo.dueDate?.toIso8601String(),
          'taskCompleted': todo.taskCompleted,
          'taskCancelled': todo.taskCancelled,
          'isFavourite': todo.isFavourite,
          'steps': todo.steps,
        }),
      );
      if (response.statusCode == 201) {
        final dynamic todoJson = json.decode(response.body);
        final createdTodo = Todo.fromJson(todoJson);
        final todos = await SharedPreferencesHelper.getTodos();
        todos.add(createdTodo);
        await SharedPreferencesHelper.saveTodos(todos);
        return createdTodo;
      } else {
        final todos = await SharedPreferencesHelper.getTodos();
        todos.add(todo);
        await SharedPreferencesHelper.saveTodos(todos);
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (e) {
      final todos = await SharedPreferencesHelper.getTodos();
      todos.add(todo);
      await SharedPreferencesHelper.saveTodos(todos);
      rethrow;
    }
  }

  // static Future<List<Todo>> searchTodos(String query) async {
  //   final todos = await getAllTodos();
  //   final matchingTodos = todos
  //       .where((todo) =>
  //       todo.task.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   return matchingTodos;
  // }


  static Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl + '/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'task': todo.task,
          'description': todo.description,
          'dateCreated': todo.dateCreated.toIso8601String(),
          'dueDate': todo.dueDate?.toIso8601String(),
          'taskCompleted': todo.taskCompleted,
          'taskCancelled': todo.taskCancelled,
          'isFavourite': todo.isFavourite,
          'id': todo.id,
          'steps': todo.steps,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final updatedTodo = Todo.fromJson(jsonResponse);
        await SharedPreferencesHelper.saveTodoToLocal(updatedTodo);
        return updatedTodo;
      } else {
        print('Failed to update todo on the backend');
      }
    } catch (e) {
      print('Error updating todo on the backend: $e');
    }
    // If updating on the backend failed or encountered an error,
    // update the local storage instead.
    await SharedPreferencesHelper.saveTodoToLocal(todo);
    return todo;
  }

  static Future<void> deleteTodoById(int id) async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + '/todos/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete todo on the backend');
      }
    } catch (error) {
      print('Failed to connect to the backend. Deleting todo locally.');
    }
    await SharedPreferencesHelper.deleteTodoFromLocal(id);
  }

  static Future<void> deleteAllTodos() async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + '/todos'));

      if (response.statusCode == 204) {
        await SharedPreferencesHelper.deleteAllTodosFromLocal();
      } else {
        print('Failed to delete all todos on the backend, attempting to delete locally');
        await SharedPreferencesHelper.deleteAllTodosFromLocal();
      }
    } catch (e) {
      print('Error deleting all todos on the backend: ${e.toString()}');
      await SharedPreferencesHelper.deleteAllTodosFromLocal();
    }
  }

}
