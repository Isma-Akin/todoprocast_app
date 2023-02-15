part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {
  final List<Todo> todos;

  const LoadTodos({
    this.todos = const <Todo>[],
});

  @override
  List<Object> get props => [todos];
}

class AddTodo extends TodosEvent {
  final Todo todo;

  const AddTodo({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodosEvent{
  final Todo todo;

  const UpdateTodo({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}

class RemoveTodo extends TodosEvent{
  final Todo todo;

  const RemoveTodo({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}