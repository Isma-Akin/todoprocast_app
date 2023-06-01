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
      body: SingleChildScrollView(
        primary: false,
        physics: const BouncingScrollPhysics(),
        child: Column(
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
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.green[200],),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/eat-that-frog-2.png'),
                  colorFilter: ColorFilter.mode(
                    Colors.orange.withOpacity(0.7),
                    BlendMode.dstATop,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Text(
                    ' ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.green[200],),
            EatThatFrogInstructionsPanel(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: BlocBuilder<TodosStatusBloc, TodosStatusState>(
                builder: (context, todosState) {
                  if (todosState is TodosStatusLoaded) {
                    final todos = todosState.pendingTodos;
                    return ListView.builder(
                      shrinkWrap: true,
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
      ),
    );
  }
}

class EatThatFrogInstructionsPanel extends StatefulWidget {
  @override
  _EatThatFrogInstructionsPanelState createState() => _EatThatFrogInstructionsPanelState();
}

class _EatThatFrogInstructionsPanelState extends State<EatThatFrogInstructionsPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                leading: Icon(Icons.info),
                title: Text('Eat That Frog Instructions'),
              );
            },
            body: Column(
              children: const [
                ListTile(
                  title: Text('1. Find out what you want to achieve most.'),
                ),
                ListTile(
                  title: Text('2. Write down your goals.'),
                ),
                ListTile(
                  title: Text('3. Set deadlines.'),
                ),
                ListTile(
                  title: Text('3. Set deadlines.'),
                ),
                ListTile(
                  title: Text('4. Make a list of everything you need to do.'),
                ),
                ListTile(
                  title: Text('5. Prioritize your list.'),
                ),
                ListTile(
                  title: Text('6. Start with the most important task.'),
                ),
                ListTile(
                  title: Text('7. Do the hardest task first.'),
                ),
                ListTile(
                  title: Text('8. Make a habit of eating that frog.'),
                ),
                ListTile(
                  title: Text('9. Review your goals daily.'),
                ),
                ListTile(
                  title: Text('10. Celebrate your success!'),
                ),
              ],
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}