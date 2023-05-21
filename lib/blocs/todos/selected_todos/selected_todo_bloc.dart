
import 'package:todoprocast_app/blocs/todos/selected_todos/selected_todo_event.dart';
import 'package:todoprocast_app/blocs/todos/selected_todos/selected_todo_state.dart';

import '../../blocs.dart';

class SelectedTodoBloc extends Bloc<SelectTodo, SelectedTodoState> {
  SelectedTodoBloc() : super(SelectedTodoState(null)) {
    on<SelectTodo>(_onSelectTodo);
  }

  void _onSelectTodo(SelectTodo event, Emitter<SelectedTodoState> emit) {
    emit(SelectedTodoState(event.todo));
  }
}

