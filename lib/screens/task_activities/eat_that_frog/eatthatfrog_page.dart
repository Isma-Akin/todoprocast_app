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
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/cloudbackground.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.green[900]?.withOpacity(0.6),
                ),
              ],
            )
        ),
        title: Text(
          'Eat that frog',
          style: GoogleFonts.openSans(fontSize: 28),
        ),
        centerTitle: true,
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
