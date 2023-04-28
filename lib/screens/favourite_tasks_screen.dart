import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
import 'package:todoprocast_app/constants.dart';

import '../models/todo_models.dart';
import '../widgets/todos_card.dart';
import 'add_todo_screen.dart';

class FavouriteTasksScreen extends StatefulWidget {
  const FavouriteTasksScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteTasksScreen> createState() => _FavouriteTasksScreenState();
}
enum TodoSortCriteria { dateCreated, alphabetically }

class _FavouriteTasksScreenState extends State<FavouriteTasksScreen> {
  final List<Todo> _todos = [];
  TodoSortCriteria _sortCriteria = TodoSortCriteria.dateCreated;
  final TodoSortCriteria _sortCriteria2 = TodoSortCriteria.alphabetically;


  List<Todo> _sortTodos(List<Todo> todos) {
    switch (_sortCriteria) {
      case TodoSortCriteria.dateCreated:
        return todos..sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
      default:
        return todos..sort((a, b) => a.task.compareTo(b.task));
    }
  }

  void _addTodo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: AddTodoScreen(todosBloc: context.read<TodosBloc>()),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            backgroundColor: appcolors[2],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              _addTodo(context);
            },
            child: const Icon(Icons.add, size: 30),
            elevation: 1,
          ),
          appBar: AppBar(
            actions: [
              PopupMenuButton<TodoSortCriteria>(
                icon: const Icon(Icons.sort),
                initialValue: _sortCriteria,
                onSelected: (value) {
                  setState(() {
                    _sortCriteria = value;
                    _sortTodos(_todos);
                  });
                },
                itemBuilder: (BuildContext context) =>
                [
                  const PopupMenuItem(
                    value: TodoSortCriteria.dateCreated,
                    child: Text('Sort by date created'),
                  ),
                  const PopupMenuItem(
                    value: TodoSortCriteria.alphabetically,
                    child: Text('Sort alphabetically'),
                  ),
                ],)
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: AppColors.tertiaryColor,
            title: const Text('Favourite Tasks'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/cloudbackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BlocBuilder<TodosBloc, TodosState>(
                builder: (context, state) {
                  BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
                  if (state is TodosLoaded) {
                    final favouriteTodos = state.todos.where(
                            (todo) => todo.isFavourite ?? false).toList();
                    if (favouriteTodos.isEmpty) {
                      return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No favourite tasks yet',
                                style: TextStyle(fontSize: 30),),
                              SizedBox(width: 10,),
                              Icon(Icons.sticky_note_2)
                            ],
                          ));
                    } else {
                      return ListView.builder(
                          itemCount: _sortTodos(favouriteTodos).length,
                          itemBuilder: (context, index) {
                            final todo = _sortTodos(favouriteTodos)[index];
                            return todosCard(context, todo);
                          }
                      );
                    }
                  } else {
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Loading...',
                              style: const TextStyle(fontSize: 30),),
                            CircularProgressIndicator(color: Colors.orange,),
                          ],
                        ));
                  }
                }),
          ),
        ));
  }
}
