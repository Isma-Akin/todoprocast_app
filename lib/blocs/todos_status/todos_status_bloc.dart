import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:todoprocast_app/blocs/todos/todos_bloc.dart';
import 'package:todoprocast_app/models/models.dart';

part 'todos_status_event.dart';
part 'todos_status_state.dart';


class TodosStatusBloc extends Bloc<TodosStatusEvent, TodosStatusState> {
  final TodosBloc _todosBloc;
  late StreamSubscription _todosSubscription;

  TodosStatusBloc({required TodosBloc todosBloc})
      : _todosBloc = todosBloc,
        super(TodosStatusLoading()) {
    on<UpdateTodosStatus>(_onUpdateTodosStatus);

    _todosSubscription = _todosBloc.stream.listen((state) {
      if (state is TodosLoaded) {
        add(
          UpdateTodosStatus(todos: state.todos),
        );
      }
    });
  }

  void _onUpdateTodosStatus(
    UpdateTodosStatus event,
    Emitter<TodosStatusState> emit,
  ) {
    List<Todo> pendingTodos = event.todos
        .where((todo) => todo.taskCancelled == false && todo.taskCompleted == false)
        .toList();
    List<Todo> completedTodos = event.todos
        .where((todo) => todo.taskCompleted == true && todo.taskCancelled == false)
        .toList();
    List<Todo> cancelledTodos =
        event.todos.where((todo) => todo.taskCancelled == false).toList();

    emit(
      TodosStatusLoaded(
        pendingTodos: pendingTodos,
        completedTodos: completedTodos,
        cancelledTodos: cancelledTodos,
      ),
    );
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }
}