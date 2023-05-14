import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/models/todo_models.dart';

class SharedPreferencesHelper {
  static const String _kTodosKey = 'todos';
  static const String _kLastUsedIdKey = 'last_used_id';

  static Future<List<Todo>> getTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString(_kTodosKey);
    if (todosJson == null) {
      return [];
    }
    final List<dynamic> todoListJson = json.decode(todosJson);
    return todoListJson.map((json) => Todo.fromJson(json)).toList();
  }

  static Future<bool> saveTodos(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final todosJson = json.encode(todos.map((todo) => todo.toJson()).toList());
    return prefs.setString(_kTodosKey, todosJson);
  }

  static Future<bool> saveTodoToLocal(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Todo> todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
    } else {
      todos.add(todo);
    }
    return saveTodos(todos);
  }

  static Future<bool> saveLastUsedId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_kLastUsedIdKey, id);
  }

  static Future<int> getLastUsedId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kLastUsedIdKey) ?? 0; // return 0 if no id has been stored yet
  }

  static Future<bool> removeTodoFromLocal(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Todo> todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos.removeAt(index);
      return saveTodos(todos);
    }
    return false;
  }

  static Future<bool> deleteTodoFromLocal(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString(_kTodosKey);
    if (todosJson == null) {
      return false;
    }
    final List<dynamic> todoListJson = json.decode(todosJson);
    final List<Todo> todos =
    todoListJson.map((json) => Todo.fromJson(json)).toList();
    final int index =
    todos.indexWhere((todo) => todo.id != null && todo.id == id);
    if (index == -1) {
      return false;
    }
    todos.removeAt(index);
    final updatedTodosJson =
    json.encode(todos.map((todo) => todo.toJson()).toList());
    return prefs.setString(_kTodosKey, updatedTodosJson);
  }

  static Future<bool> deleteAllTodosFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_kTodosKey);
  }
}


