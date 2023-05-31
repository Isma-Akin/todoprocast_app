import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';


class EatThatFrogPage extends StatelessWidget {
  const EatThatFrogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          child: SafeArea(
            child: Center(
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.navigate_before_rounded, size: 30,),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.table_rows_rounded),
                    onPressed: () {
                      // context.read<ParkinsonsLawBloc>().add(StopCountdownEvent());
                    },
                  ),
                  title: Center(
                    child: Text(
                      'Eat that Frog',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ),),
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloudbackground.jpg'),
              colorFilter: ColorFilter.mode(
                Colors.green.withOpacity(0.7),
                BlendMode.srcATop,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ) ,
      ),
      body: Column(
        children: [
          // BlocBuilder<TodosBloc, TodosState>(
          //   builder: (context, state) {
          //     if (state is TodosLoaded) {
          //       final frogs = state.todos.where((todo) => todo.isFrog).toList();
          //       return SizedBox(
          //         height: 100,
          //         child: ListView.builder(
          //           itemCount: frogs.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(frogs[index].task),
          //               // other list tile properties...
          //             );
          //           },
          //         ),
          //       );
          //     } else {
          //       return const CircularProgressIndicator();
          //     }
          //   },
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: BlocBuilder<TodosStatusBloc, TodosStatusState>(
              builder: (context, todosState) {
                if (todosState is TodosStatusLoaded) {
                  final todos = todosState.pendingTodos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(todo.task),
                        subtitle: Text(todo.description),
                        trailing: Switch(
                          value: todo.isFrog,
                          onChanged: (newValue) {
                            final updatedTodo = todo.copyWith(isFrog: newValue);
                            if (newValue) {
                              updatedTodo.updateTaskActivity('Eat that Frog');
                            }
                            context
                                .read<TodosBloc>()
                                .add(UpdateTodo(todo: updatedTodo));
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<TodosBloc>(),
                                  child: TodoDetailScreen(todo: todo),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (todosState is TodosStatusLoading) {
                  return Column(
                    children: const [
                      Text('Loading...'),
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  return const Text('Something went wrong!');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
