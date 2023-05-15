import 'package:todoprocast_app/models/todo_models.dart';

class Group {
  final String name;
  final List<Todo> todos;

  Group({
    required this.name,
    required this.todos,
  });

  Group copy() {
    return Group(
      name: name,  // Copy the name
      todos: this.todos.map((todo) => todo.copy()).toList(),  // Use the Todo class's copy method
    );
  }

  Group copyWith({
    String? name,
    List<Todo>? todos,
  }) {
    return Group(
      name: name ?? this.name,
      todos: todos ?? this.todos,
    );
  }

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

  // factory Group.fromJson(Map<String, dynamic> json) {
  //   return Group(
  //     name: json['name'],
  //     todos: (json['todos'] as List)
  //         .map((i) => Todo.fromJson(i as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'todos': todos.map((todo) => todo.toJson()).toList(),
  //   };
  // }
}

