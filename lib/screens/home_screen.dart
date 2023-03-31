import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoprocast_app/constants.dart';


import '../widgets/todos_card.dart';
import '/models/models.dart';
import '/blocs/blocs.dart';
import 'add_todo.dart';
import 'add_todo_screen.dart';

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
        color: appcolors[2],
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: appcolors[2],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          onPressed: () {
            _addTodo(context);
          },child: const Icon(Icons.add, size: 30),
            elevation: 1,
        ),
            appBar: AppBar(
              backgroundColor: appcolors[2],
              actions: [IconButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) => const Add_ToDo()));},
                  icon: const Icon(Icons.add)),
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
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _todo(
                            state.pendingTodos,
                            'Pending',
                          ),
                          if (state.pendingTodos.isEmpty)
                            Column(
                              children: const [
                                Text('You have no pending tasks yet.', style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 20,),
                                Text('Add a task by clicking the + button below.', style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                              ],
                            ),
                          _todo(
                            state.completedTodos,
                            'Completed',
                          ),
                          if (state.completedTodos.isEmpty)
                            const Text('You have no completed tasks yet.', style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
        ));
  }


Column _todo(List<Todo> todos, String status) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(
              '$status Tasks: ${todos.length}',
              style: const TextStyle(
                fontSize: 20,
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
          return todosCard(
            context,
            todos[index],
          );
        },
      ),
    ],
  );
}
}