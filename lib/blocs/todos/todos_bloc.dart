import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/blocs/blocs.dart';

import '../../models/todo_models.dart';
import '../../api/todo_repository.dart';
import '/models/models.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {

  final TodoRepository _todoRepository;
  final SharedPreferences _prefs;

  TodosBloc(this._todoRepository, this._prefs,) : super(TodosInitial()) {
    print('TodosBloc constructor called');
    on<LoadTodos>(_onLoadTodos);
    // on<SearchTodos>(_onSearchTodos);
    on<AddTodo>(_onAddTodos);
    on<UpdateTodo>(_onUpdateTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<MarkTodoAsFavOrUnFav>(_onMarkTodoAsFavOrUnFav);
    on<RemoveAllTodos>(_onRemoveAllTodos);
    on<SortTodosByDueDate>(_mapSortTodosByDueDateToState);
    on<SortTodosByDateCreated>(_mapSortTodosByDateCreatedToState);
    on<SortTodosAlphabetically>(_mapSortTodosAlphabeticallyToState);
    on<UpdateDueDateEvent>(_onUpdateDueDate);
    }

  void _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString('todos');
      if (todosJson != null) {
        final todos = (json.decode(todosJson) as List)
            .map((e) => Todo.fromJson(e))
            .toList();
        emit(TodosLoaded(todos: todos));
      } else {
        final todos = await TodoRepository.getAllTodos();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error loading todos. Endpoint down?'));
    }
  }

  // void _onSearchTodos(SearchTodos event, Emitter<TodosState> emit) async{
  //   if (state is TodosLoaded) {
  //     final todos = (state as TodosLoaded).todos;
  //     final filteredTodos = todos
  //         .where((todo) =>
  //         todo.task.toLowerCase().contains(event.query.toLowerCase()))
  //         .toList();
  //     emit(TodosLoaded(todos: filteredTodos));
  //   }
  // }



  // void _onSearchTodos(SearchTodos event, Emitter<TodosState> emit) async {
  //   try {
  //     final todos = await TodoRepository.searchTodos(event.query);
  //     emit(TodosLoaded(todos: todos));
  //   } catch (error) {
  //     emit(TodosError(
  //         error: error.toString(),
  //         message: 'Error searching todos. Endpoint down?'));
  //   }
  // }

  //Old method for reference
  // void _onLoadTodos(
  //     LoadTodos event,
  //     Emitter<TodosState> emit,
  //     ) {
  //   emit(TodosLoaded(todos: event.todos));
  // }

  // void _onAddTodos(
  //     AddTodo event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   try {
  //     final todo = await TodoRepository.createTodo(event.todo);
  //     final prefs = await SharedPreferences.getInstance();
  //     final todosJson = prefs.getString('todos');
  //     if (todosJson != null) {
  //       final todos = (json.decode(todosJson) as List)
  //           .map((e) => Todo.fromJson(e))
  //           .toList();
  //       todos.add(todo);
  //       prefs.setString('todos', json.encode(todos));
  //       emit(TodosLoaded(todos: todos));
  //     } else {
  //       prefs.setString('todos', json.encode([todo]));
  //       emit(TodosLoaded(todos: [todo]));
  //     }
  //   } catch (error) {
  //     emit(TodosError(
  //         error: error.toString(),
  //         message: 'Error adding todo. Endpoint down?'));
  //   }
  // }

  void _onAddTodos(
      AddTodo event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final todo = await TodoRepository.createTodo(event.todo);
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString('todos');
      if (todosJson != null) {
        final todos = (json.decode(todosJson) as List)
            .map((e) => Todo.fromJson(e))
            .toList();
        if (todos.any((t) => t.id == todo.id)) {
          // If the todo already exists, don't add it again
          emit(TodosLoaded(todos: todos));
        } else {
          todos.add(todo);
          prefs.setString('todos', json.encode(todos));
          emit(TodosLoaded(todos: todos));
        }
      } else {
        prefs.setString('todos', json.encode([todo]));
        emit(TodosLoaded(todos: [todo]));
      }
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error adding todo. Endpoint down?'));
    }
  }

  //Old method for reference
  // void _onAddTodos(
  //     AddTodo event,
  //     Emitter<TodosState> emit,
  //     ) {
  //   final state = this.state;
  //   if (state is TodosLoaded) {
  //     emit(
  //         TodosLoaded(
  //           todos: List.from(state.todos)..add(event.todo),
  //         )
  //     );
  //   }
  // }

  void _onUpdateTodo(
      UpdateTodo event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final todo = await TodoRepository.updateTodo(event.todo);
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString('todos');
      if (todosJson != null) {
        final todos = (json.decode(todosJson) as List)
            .map((e) => Todo.fromJson(e))
            .toList();
        final updatedTodos = todos.map((t) {
          return t.id == todo.id ? todo : t;
        }).toList();
        prefs.setString('todos', json.encode(updatedTodos));
        emit(TodosLoaded(todos: updatedTodos));
      } else {
        emit(TodosError(
            error: 'No todos found in shared preferences',
            message: 'Error updating todo'));
      }
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error updating todo. Endpoint down?'));
    }
  }

  // void _onUpdateTodo(
  //     UpdateTodo event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   try {
  //     final updatedTodo = event.todo.copyWith(dueDate: event.dueDate);
  //     await TodoRepository.updateTodo(updatedTodo);
  //     emit(TodoDueDateUpdated(todo: updatedTodo, dueDate: event.dueDate));
  //   } catch (error) {
  //     emit(TodosError(error: error.toString(), message: 'Error updating todo.'));
  //   }
  // }

  void _onRemoveTodo(RemoveTodo event, Emitter<TodosState> emit) async {
    try {
      await TodoRepository.deleteTodoById(event.todo.id);
      emit(TodosLoaded(todos: await TodoRepository.getAllTodos()));
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error removing todo. Endpoint down?'));
    }
  }
    // void _onMarkTodoAsFavOrUnFav(
  //     MarkTodoAsFavOrUnFav event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   final state = this.state;
  //   if (state is TodosLoaded) {
  //     List<Todo> todos = (state.todos.map((todo) {
  //       return todo.id == event.todo.id
  //           ? event.todo.copyWith(isFavourite: !event.todo.isFavourite!)
  //           : todo;
  //     })).toList();
  //     try {
  //       await TodoRepository.updateTodo(event.todo.copyWith(
  //         isFavourite: !event.todo.isFavourite!,
  //       ));
  //       emit(TodosLoaded(todos: todos));
  //     } catch (e) {
  //       emit(TodosError(error: e.toString(), message: 'Error removing todo. Endpoint down?'));
  //     }
  //   }
  // }

  void _onMarkTodoAsFavOrUnFav(
      MarkTodoAsFavOrUnFav event,
      Emitter<TodosState> emit,
      ) async {
    final state = this.state;
    if (state is TodosLoaded) {
      try {
        final updatedTodo = event.todo.copyWith(
          isFavourite: !(event.todo.isFavourite ?? false),
        );
        final prefs = await SharedPreferences.getInstance();
        final todosJson = prefs.getString('todos');
        if (todosJson != null) {
          final todos = (json.decode(todosJson) as List)
              .map((e) => Todo.fromJson(e))
              .toList();
          final updatedTodos = todos.map((t) {
            return t.id == updatedTodo.id ? updatedTodo : t;
          }).toList();
          // Store the updated todos list in shared preferences
          await prefs.setString('todos', json.encode(updatedTodos));
          // Update the state in TodosBloc
          emit(TodosLoaded(todos: updatedTodos));
        } else {
          emit(TodosError(
              error: 'No todos found in shared preferences',
              message: 'Error updating todo in shared preferences'));
        }
        // Remove the response status code from the TodoRepository update method call
        await TodoRepository.updateTodo(updatedTodo);
      } catch (e) {
        emit(TodosError(
            error: e.toString(), message: 'Error updating todo. Endpoint down?'));
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

  // void _onUpdateDueDate(
  //     UpdateDueDateEvent event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   try {
  //     final updatedTodo = event.todo.copyWith(dueDate: event.dueDate);
  //     final todo = await TodoRepository.updateTodo(updatedTodo);
  //     final state = this.state;
  //     if (state is TodosLoaded) {
  //       final todos = state.todos.map((t) {
  //         return t.id == todo.id ? todo : t;
  //       }).toList();
  //       emit(TodosLoaded(todos: todos));
  //     }
  //   } catch (error) {
  //     emit(TodosError(
  //         error: error.toString(),
  //         message: 'Error updating todo due date. Endpoint down?'));
  //   }
  // }
  void _onUpdateDueDate(
      UpdateDueDateEvent event,
      Emitter<TodosState> emit,
      ) async {
    try {
      final updatedTodo = event.todo.copyWith(dueDate: event.dueDate);

      // Update todo in backend
      final todo = await TodoRepository.updateTodo(updatedTodo);

      // Update todo in shared preferences
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString('todos');
      if (todosJson != null) {
        final todos = (json.decode(todosJson) as List)
            .map((e) => Todo.fromJson(e))
            .toList();
        final updatedTodos = todos.map((t) {
          return t.id == todo.id ? todo : t;
        }).toList();
        prefs.setString('todos', json.encode(updatedTodos));
      }
      // Update state with updated todos
      final state = this.state;
      if (state is TodosLoaded) {
        final todos = state.todos.map((t) {
          return t.id == todo.id ? todo : t;
        }).toList();
        emit(TodosLoaded(todos: todos));
      }
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error updating todo due date. Endpoint down?'));
    }
  }

  // void _onRemoveAllTodos(
  //     RemoveAllTodos event,
  //     Emitter<TodosState> emit,
  //     ) async {
  //   try {
  //     await TodoRepository.deleteAllTodos();
  //     emit(const TodosLoaded(todos: []));
  //   } catch (error) {
  //     emit(TodosError(error: error.toString(), message: 'Error removing all todos. Endpoint down?'));
  //   }
  // }

  void _onRemoveAllTodos(
      RemoveAllTodos event,
      Emitter<TodosState> emit,
      ) async {
    try {
      await TodoRepository.deleteAllTodos();

      // Remove all todos from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('todos');

      emit(const TodosLoaded(todos: []));
    } catch (error) {
      emit(TodosError(
          error: error.toString(),
          message: 'Error removing all todos. Endpoint down?'));
    }
  }

}