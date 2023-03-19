import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/logic/navigation/constants/nav_bar_items.dart';
import 'package:todoprocast_app/logic/navigation/navigation_cubit.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';
import 'package:todoprocast_app/services/profile.dart';
import 'package:todoprocast_app/services/settings.dart';
// import 'package:todoprocast_app/screens/profile_screen.dart';
// import 'package:todoprocast_app/screens/settings_screen.dart';
import 'package:todoprocast_app/screens/initial_screen.dart';


import '/models/models.dart';
import '../services/screens.dart';
import '/blocs/blocs.dart';
import 'add_todo.dart';
import 'add_todo_screen.dart';
import 'initial_screen.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _addTodo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddTodoScreen(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo app",
        debugShowCheckedModeBanner: false,
        color: Colors.blue,
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTodo(context);
          },child: const Icon(Icons.add),
            elevation: 2,
        ),
          // drawer: buildDrawer(context),
          // bottomNavigationBar: NavBar(),
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              actions: [IconButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) => const Add_ToDo()));},
                  icon: Icon(Icons.add)),
                // PopupMenuButton(
                //     onSelected: (value) {
                //       switch (value) {
                //         case 'sort':
                //           BlocProvider.of<TodosStatusBloc>(context)
                //               .add(TodosStatusSorted());
                //           break;
                //           case 'duplicate':
                //           BlocProvider.of<TodosStatusBloc>(context)
                //               .add(TodosStatusDuplicated());
                //           break;
                //         case 'delete':
                //           BlocProvider.of<TodosStatusBloc>(context)
                //               .add(TodosStatusDeleted());
                //           break;}
                //       },
                //     itemBuilder: (BuildContext context) {
                //       return [
                //         PopupMenuItem(
                //           child: const Text('Sort'),
                //           value: 'sort',
                //         ),
                //         PopupMenuItem(
                //           child: const Text('Duplicate'),
                //           value: 'duplicate',
                //         ),
                //         PopupMenuItem(
                //           child: const Text('Delete'),
                //           value: 'delete',
                //         ),
                //       ];
                //     }),
              ],
              title: const Text("Tasks",
              style: TextStyle(fontSize: 30)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: BlocBuilder<TodosStatusBloc, TodosStatusState>(
              builder: (context, state) {
                if (state is TodosStatusLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TodosStatusLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _todo(
                          state.pendingTodos,
                          'Pending',
                        ),
                        if (state.pendingTodos.isEmpty)
                          SizedBox(height: 40,
                            width: 200,
                            child: ElevatedButton(onPressed: () => {
                              _addTodo(context),
                            }, child: Text("Add todo")),
                          ),
                        _todo(
                          state.completedTodos,
                          'Completed',
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
        ));
  }


  Drawer buildDrawer(BuildContext context) {
    return Drawer(
          child: ListView(
              children: [
                ListTile(
                  title: const Text("Main page"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: const Text("Todo list"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Add_ToDo(),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  },
                ),
                Divider(),
              ]),
        );
  }

  BlocBuilder<NavigationCubit, NavigationState> NavBar() {
    return BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.index,
              showUnselectedLabels: false,
              onTap: (index) {
                if (index == 0) { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
                BlocProvider.of<NavigationCubit>(context)
                    .updateNavBarItem(NavBarItem.settings);
                  BlocProvider.of<NavigationCubit>(context)
                      .updateNavBarItem(NavBarItem.home);
                } else if (index == 1) { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
                  BlocProvider.of<NavigationCubit>(context)
                      .updateNavBarItem(NavBarItem.settings);
                } else if (index == 2) { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
                BlocProvider.of<NavigationCubit>(context)
                    .updateNavBarItem(NavBarItem.settings);
                  BlocProvider.of<NavigationCubit>(context)
                      .updateNavBarItem(NavBarItem.profile);
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },);
  }
}

Column _todo(List<Todo> todos, String status) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              '$status To Dos: ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return _todosCard(
            context,
            todos[index],
          );
        },
      ),
    ],
  );
}

InkWell _todosCard(
    BuildContext context,
    Todo todo,
    ) {
  return InkWell(
    splashColor: Colors.blue.withAlpha(30),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailScreen(todo: todo),
        ),
      );
    },
    child: Card(
      color: todo.taskCompleted == true ? Colors.orange : Colors.blue,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<TodosBloc>().add(
                MarkTodoAsFavOrUnFav(todo: todo));
                      },
                      icon: Icon(
                          todo.isFavourite! ? Icons.star : Icons.star_border),
                      color: Colors.yellow,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: IconButton(
                        onPressed: () {
                          context.read<TodosBloc>().add(
                            UpdateTodo(
                              todo: todo.copyWith(taskCompleted: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_task),
                      ),
                    ),IconButton(
                      onPressed: () {
                        context.read<TodosBloc>().add(
                          RemoveTodo(
                            todo: todo.copyWith(taskCancelled: true),
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}