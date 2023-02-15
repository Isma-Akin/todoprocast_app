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

 @override
  List<Object> get props [todos];
}