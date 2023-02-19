import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/logic/navigation/constants/nav_bar_items.dart';
import 'package:todoprocast_app/logic/navigation/navigation_cubit.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:todoprocast_app/screens/profile.dart';
import 'package:todoprocast_app/screens/settings.dart';
// import 'package:todoprocast_app/screens/profile_screen.dart';
// import 'package:todoprocast_app/screens/settings_screen.dart';

import '/models/models.dart';
import '/screens/screens.dart';
import '/blocs/blocs.dart';
import 'add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo app",
        debugShowCheckedModeBanner: false,
        color: Colors.blue,
        home: Scaffold(
          bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: state.index,
                showUnselectedLabels: false,
                onTap: (index) {
                  if (index == 0) { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
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
            },),
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              actions: [IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Add_ToDo(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              tooltip: "Click here to add new todo"),],
              title: const Text("Todo app",
              style: TextStyle(fontSize: 30)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _todo(
                          state.pendingTodos,
                          'Pending',
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

Card _todosCard(
    BuildContext context,
    Todo todo,
    ) {
  return Card(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/todo/${todo.id}');
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
                  ),
                  IconButton(
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
  );
}
