import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_models.dart';
import '../../api/todo_repository.dart';
import '/models/models.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodos);
    on<UpdateTodo>(_onUpdateTodo);
    on<RemoveTodo>(_onRemoveTodo);
    // on<EditTodo>(_onEditTodo);
    on<MarkTodoAsFavOrUnFav>(_onMarkTodoAsFavOrUnFav);
    on<RemoveAllTodos>(_onRemoveAllTodos);
    on<SortTodosByDueDate>(_mapSortTodosByDueDateToState);
    on<SortTodosByDateCreated>(_mapSortTodosByDateCreatedToState);
    on<SortTodosAlphabetically>(_mapSortTodosAlphabeticallyToState);
    }

  void _onLoadTodos(
      LoadTodos event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final todos = await TodoRepository.getAllTodos();
      emit(TodosLoaded(todos: todos));
    } catch (error) {
      emit(TodosError(error: error.toString(), message: 'Error loading todos. Endpoint down?'));
    }
  }

  void _onAddTodos(
      AddTodo event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final todo = await TodoRepository.createTodo(event.todo);
      final state = this.state;
      if (state is TodosLoaded) {
        final todos = List<Todo>.from(state.todos)..add(todo);
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      emit(TodosError(error: error.toString(), message: 'Error adding todo. Endpoint down?'));
    }
  }

  // void _onAddTodos(
  //     AddTodo event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   try {
  //     // Remove the id field from the event.todo object
  //     final todoWithoutId = event.todo.copyWith(id: null);
  //
  //     // Create the todo in the repository
  //     final todo = await TodoRepository.createTodo(todoWithoutId);
  //
  //     // Update the state with the new todo
  //     final state = this.state;
  //     if (state is TodosLoaded) {
  //       final todos = List<Todo>.from(state.todos)..add(todo);
  //       emit(TodosLoaded(todos: todos));
  //     }
  //   } catch (error) {
  //     emit(TodosError(error: error.toString(), message: 'Error adding todo'));
  //   }
  // }
  void _onUpdateTodo(
      UpdateTodo event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final todo = await TodoRepository.updateTodo(event.todo);
      final state = this.state;
      if (state is TodosLoaded) {
        final todos = state.todos.map((t) {
          return t.id == todo.id ? todo : t;
        }).toList();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      emit(TodosError(error: error.toString(), message: 'Error updating todo. Endpoint down?'));
    }
  }

  void _onRemoveTodo(
      RemoveTodo event,
      Emitter<TodosState> emit,
      ) async {
    try {
      await TodoRepository.deleteTodoById(event.todo.id);
      final state = this.state;
      if (state is TodosLoaded) {
        final todos = state.todos.where((t) => t.id != event.todo.id).toList();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      emit(TodosError(error: error.toString(), message: 'Error removing todo. Endpoint down?'));
    }
  }

  void _onMarkTodoAsFavOrUnFav(
      MarkTodoAsFavOrUnFav event,
      Emitter<TodosState> emit,
      ) async {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.map((todo) {
        return todo.id == event.todo.id
            ? event.todo.copyWith(isFavourite: !event.todo.isFavourite!)
            : todo;
      })).toList();
      try {
        await TodoRepository.updateTodo(event.todo.copyWith(
          isFavourite: !event.todo.isFavourite!,
        ));
        emit(TodosLoaded(todos: todos));
      } catch (e) {
        emit(TodosError(error: e.toString(), message: 'Error removing todo. Endpoint down?'));
      }
    }
  }

  void _mapSortTodosByDueDateToState(
      SortTodosByDueDate event,
      Emitter<TodosState> emit,
      ) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> sortedTodos = List.from(state.todos)..sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
      emit(TodosLoaded(todos: sortedTodos));
    }
  }

  void _mapSortTodosByDateCreatedToState(
      SortTodosByDateCreated event,
      Emitter<TodosState> emit,
      ) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> sortedTodos = state.todos.toList()..sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
      emit(TodosLoaded(todos: sortedTodos));
    }
  }

  void _mapSortTodosAlphabeticallyToState(
      SortTodosAlphabetically event,
      Emitter<TodosState> emit,
      ) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> sortedTodos = List.from(state.todos)..sort((a, b) => a.task.compareTo(b.task));
      emit(TodosLoaded(todos: sortedTodos));
    }
  }

  void _onRemoveAllTodos(
      RemoveAllTodos event,
      Emitter<TodosState> emit,
      ) async {
    try {
      await TodoRepository.deleteAllTodos();
      emit(const TodosLoaded(todos: []));
    } catch (error) {
      emit(TodosError(error: error.toString(), message: 'Error removing all todos. Endpoint down?'));
    }
  }
}