part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();
}

class TodosInitial extends TodosState {
  @override
  List<Object> get props => [];
}

class TodosLoaded extends TodosState {
  final List<Todo> todos;

 const TodosLoaded({
    this.todos = const<Todo>[],
});

 List<Todo> getFavouriteTodos() {
   return todos.where((todo) => todo.isFavourite ?? false).toList();
 }

 @override
  List<Object> get props => [todos];
}

class TodosSortedByDate extends TodosState {
  final List<Todo> todos;

 const TodosSortedByDate({
    this.todos = const<Todo>[],
});

 @override
  List<Object> get props => [todos];
}

class TodoDueDateUpdated extends TodosState {
  final Todo todo;
  final DateTime? dueDate;

  const TodoDueDateUpdated({required this.todo, required this.dueDate});

  @override
  List<Object?> get props => [todo, dueDate];
}

class TodosError extends TodosState {
  final String message;

 const TodosError({
    required this.message, required String error,
});

 @override
  List<Object> get props => [message];
}