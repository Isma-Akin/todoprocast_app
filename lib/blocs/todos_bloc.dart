import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../main.dart';
import '../models/todo_models.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosInitial()) {
    on<TodosEvent>((event, emit) {
      // TODO: implement event handler
    });
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

        )
      }
  }


}
