import 'package:todoprocast_app/models/todo_models.dart';

class Group {
  final String name;
  final List<Todo> todos;

  Group({
    required this.name,
    required this.todos,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    if (json['group'] == null) {
      return Group(name: '', todos: []); // return an empty Group object
    } else {
      var todoListJson = json['todos'] as List;
      List<Todo> todoList = todoListJson.map((todo) => Todo.fromJson(todo)).toList();

      return Group(
        name: json['name'],
        todos: todoList,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'todos': todos.map((t) => t.toJson()).toList(),
    };
  }
}
