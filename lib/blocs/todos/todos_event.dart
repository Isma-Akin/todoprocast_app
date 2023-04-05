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

class EditTodo extends TodosEvent {
  final Todo oldTodo;
  final Todo newTodo;

  const EditTodo({
    required this.oldTodo,
    required this.newTodo,
});

  @override
  List<Object> get props => [
    oldTodo,
    newTodo
  ];
}

class UpdateTodo extends TodosEvent {
  // final Todo oldTodo;
  // final Todo newTodo;
  final Todo todo;

  const UpdateTodo({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}

class MarkTodoAsFavOrUnFav extends TodosEvent {
  final Todo todo;

  const MarkTodoAsFavOrUnFav({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}

class SortTodosByDueDate extends TodosEvent {
  final List<Todo> todos;

  const SortTodosByDueDate({
    required this.todos,
});

  @override
  List<Object> get props => [todos];
}

class SortTodosByDateCreated extends TodosEvent {
  final List<Todo> todos;

  const SortTodosByDateCreated({
    required this.todos,
});

  @override
  List<Object> get props => [todos];
}

class SortTodosAlphabetically extends TodosEvent {
  final List<Todo> todos;

  const SortTodosAlphabetically({
    required this.todos,
});

  @override
  List<Object> get props => [todos];
}

class AddStep extends TodosEvent {
  final Todo todoId;
  final String step;

  const AddStep({
    required this.todoId,
    required this.step,
});

  @override
  List<Object> get props => [todoId, step];
}
//
// class TodosFilterByDate extends TodosEvent {
//   final DateTime date;
//   final List<Todo> todos;
//
//   const TodosFilterByDate({required this.date, required this.todos});
//
//   @override
//   List<Object> get props => [date, todos];
// }

class RemoveTodo extends TodosEvent{
  final Todo todo;

  const RemoveTodo({
    required this.todo,
});

  @override
  List<Object> get props => [todo];
}

class RemoveAllTodos extends TodosEvent{}