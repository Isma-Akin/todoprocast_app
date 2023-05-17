import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/timeblock_models.dart';
import '../models/todo_models.dart';

class TimeBlocksRepository {

  Future<List<TaskModel>> loadTimeBlocks(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('time_blocks_${todo.id}');
    if (jsonString != null) {
      List<dynamic> decodedTasks = jsonDecode(jsonString);
      List<TaskModel> tasks = decodedTasks.map((task) => TaskModel.fromJson(task as Map<String, dynamic>)).toList();
      print('Loaded time blocks: $tasks');
      return tasks;
    } else {
      return [];
    }
  }


  Future<void> addTimeBlock(Todo todo, TaskModel task) async {
    try {
      List<TaskModel> tasks = await loadTimeBlocks(todo);
      tasks.add(task);
      await _saveTimeBlocks(todo, tasks);
    } catch (e) {
      print('Error adding time block: $e');
    }
  }


  Future<void> updateTimeBlock(Todo todo, TaskModel task) async {
    List<TaskModel> tasks = await loadTimeBlocks(todo);
    int index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveTimeBlocks(todo, tasks);
    }
  }

  Future<void> deleteTimeBlock(Todo todo, TaskModel task) async {
    List<TaskModel> tasks = await loadTimeBlocks(todo);
    tasks.removeWhere((t) => t.id == task.id);
    await _saveTimeBlocks(todo, tasks);
  }


  Future<void> _saveTimeBlocks(Todo todo, List<TaskModel> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    print('Saving time blocks: $jsonString');
    await prefs.setString('time_blocks_${todo.id}', jsonString);
  }


}
