import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_models.dart';
import '/models/models.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodos);
    on<UpdateTodo>(_onUpdateTodo);
    on<RemoveTodo>(_onRemoveTodo);
    }

  void _onLoadTodos(
    LoadTodos event,
      Emitter<TodosState> emit,
      ) {
    emit(TodosLoaded(todos: event.todos));
  }

  void _onAddTodos(
      AddTodo event,
      Emitter<TodosState> emit,
      ) {
      final state = this.state;
      if (state is TodosLoaded) {
        emit(
        TodosLoaded(
        todos: List.from(state.todos)..add(event.todo),
        )
        );
      }
  }

  void _onUpdateTodo(
      UpdateTodo event,
      Emitter<TodosState> emit,
      ) {
      final state = this.state;
      if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      })).toList();

      emit(TodosLoaded(todos: todos));
      }
  }

  void _onRemoveTodo(
      RemoveTodo event,
      Emitter<TodosState> emit,
      ) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.where((todo) {
        return todo.id != event.todo.id;
      })).toList();

      emit(TodosLoaded(todos: todos));
    }
  }
}