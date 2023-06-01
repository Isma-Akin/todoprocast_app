import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../blocs/paretos/pareto_bloc.dart';
import '../../../blocs/paretos/pareto_event.dart';
import '../../../blocs/paretos/pareto_state.dart';
import '../../../blocs/todos/selected_todos/selected_todo_bloc.dart';
import '../../../blocs/todos/selected_todos/selected_todo_event.dart';
import '../../../blocs/todos_status/todos_status_bloc.dart';
import '../../../models/pareto_models.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../models/todo_models.dart';
import '../../todo_detail_screen.dart';

class ParetoAnalysisPage extends StatefulWidget {
  const ParetoAnalysisPage({Key? key}) : super(key: key);

  @override
  State<ParetoAnalysisPage> createState() => _ParetoAnalysisPageState();
}
enum TodoSortCriteria { favourites, dueDate, alphabetically }

class _ParetoAnalysisPageState extends State<ParetoAnalysisPage> {
  // Future<void> _showAddParetoItemDialog(BuildContext context) async {
  //   TextEditingController nameController = TextEditingController();
  //   TextEditingController valueController = TextEditingController();
  //
  //
  //
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         title: const Text('Add Pareto Item'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: [
  //               TextField(
  //                 controller: nameController,
  //                 decoration: const InputDecoration(labelText: 'Name'),
  //               ),
  //               TextField(
  //                 controller: valueController,
  //                 keyboardType: TextInputType.number,
  //                 decoration: const InputDecoration(labelText: 'Value'),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Add'),
  //             onPressed: () {
  //               if (nameController.text.isNotEmpty &&
  //                   valueController.text.isNotEmpty) {
  //                 int value = int.tryParse(valueController.text) ?? 0;
  //                 ParetoItem newItem = ParetoItem(
  //                   id: const Uuid().v4(),
  //                   name: nameController.text,
  //                   value: value,
  //                 );
  //                 context.read<ParetoBloc>().add(ParetoItemAdded(newItem));
  //                 Navigator.of(dialogContext).pop();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showParetoValueDialog(BuildContext context, Todo todo) {
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add Pareto Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Value'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (valueController.text.isNotEmpty) {
                  int value = int.tryParse(valueController.text) ?? 0;
                  ParetoItem newItem = ParetoItem(
                    id: const Uuid().v4(),
                    todo: todo,
                    value: value,
                  );
                  context.read<ParetoBloc>().add(ParetoItemAdded(newItem));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  late List<Todo>? sortedTodos;
  TodoSortCriteria _sortCriteria = TodoSortCriteria.dueDate;

  List<Todo> _sortTodos(List<Todo> todos, TodoSortCriteria sortCriteria) {
    switch (sortCriteria) {
      case TodoSortCriteria.favourites:
        return todos
            .where((todo) => todo.isFavourite ?? false)
            .toList()
          ..sort((a, b) => ((b.isFavourite ?? false) ? 1 : 0) - ((a.isFavourite ?? false) ? 1 : 0));
      case TodoSortCriteria.dueDate:
        return todos..sort((a, b) => (a.dueDate?.compareTo(b.dueDate!) ?? 0));
      case TodoSortCriteria.alphabetically:
      default:
        return todos..sort((a, b) => a.task.compareTo(b.task));
    }
  }
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
                    },
                  ),
                  title: Center(
                    child: Text(
                      'Pareto analysis',
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
                Colors.purple.withOpacity(0.7),
                BlendMode.srcATop,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ) ,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: BlocBuilder<ParetoBloc, ParetoState>(
              builder: (context, state) {
                if (state is ParetoLoaded && state.items.isNotEmpty) {
                  return ParetoChart(items: state.items);
                } else if (state is ParetoLoaded && state.items.isEmpty) {
                  return _paretoBuild();
                  // return const Center(
                  //   child: Text('No items added yet. Tap the'
                  //       ' + button to add an item.'),
                  // );
                } else if (state is ParetoInitial) {
                  return _paretoBuild();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<TodosStatusBloc, TodosStatusState> _paretoBuild() {
    return BlocBuilder<TodosStatusBloc, TodosStatusState>(
      builder: (context, todosState) {
        if (todosState is TodosStatusLoaded) {
          sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);

          return Column(
            children: [
              const SizedBox(height: 5,),
              Container(
                child: Column(
                  children: [
                    Divider(
                      height: 10,
                      thickness: 2,
                      color: Colors.purple[200],),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/pareto-chart.png'),
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
                      color: Colors.purple[200],),
                    const ParetoInstructionsPanel(),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text("Select a todo", style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),),
                          const Spacer(),
                          DropdownButton<TodoSortCriteria>(
                            value: _sortCriteria,
                            items: <TodoSortCriteria>[
                              TodoSortCriteria.favourites,
                              TodoSortCriteria.dueDate,
                              TodoSortCriteria.alphabetically
                            ].map((TodoSortCriteria value) {
                              return DropdownMenuItem<TodoSortCriteria>(
                                value: value,
                                child: Text(value.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (TodoSortCriteria? value) {
                              setState(() {
                                _sortCriteria = value!;
                                sortedTodos = _sortTodos([...todosState.pendingTodos], _sortCriteria);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortedTodos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: _sortCriteria == TodoSortCriteria.favourites
                              ? const Icon(Icons.star, color: Colors.yellow,)
                              : _sortCriteria == TodoSortCriteria.dueDate
                              ? const Icon(Icons.access_time, color: Colors.blue,)
                              : _sortCriteria == TodoSortCriteria.alphabetically
                              ? const Icon(Icons.sort_by_alpha, color: Colors.deepOrange,)
                              : null,
                          title: Text(sortedTodos![index].task),
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TodoDetailScreen(todo: sortedTodos![index],)));
                          },
                          subtitle: Text("Due date: ${sortedTodos![index].formattedDueDate.toString()}",
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),),
                          onTap: () {
                            final todo = sortedTodos![index];
                            if (todo.dueDate != null) {
                              print('todo has been selected: $todo');
                              print('todo id has been selected: ${todo.id}');
                              context.read<SelectedTodoBloc>().add(SelectTodo(todo));
                              _showParetoValueDialog(context, todo);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ParetoChart extends StatelessWidget {
  final List<ParetoItem> items;

  const ParetoChart({required this.items});

  @override
  Widget build(BuildContext context) {
    List<BarChartRodData> barData = items
        .map((item) => BarChartRodData(
      y: item.value.toDouble(),
      width: 20,
    ))
        .toList();

    int cumulativeValue = 0;
    List<FlSpot> lineData = items.map((item) {
      cumulativeValue += item.value;
      return FlSpot(items.indexOf(item).toDouble(), cumulativeValue.toDouble());
    }).toList();

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: BarChart(
            BarChartData(
              barGroups: barData.map((data) {
                return BarChartGroupData(
                  x: barData.indexOf(data),
                  barRods: [data],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: true),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (double value) {
                    return items[value.toInt()].todo.task;
                  },
                ),
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
          ),
        ),
        BlocBuilder<TodosStatusBloc, TodosStatusState>(
          builder: (context, todosState) {
            if (todosState is TodosStatusLoaded) {
              final availableTodos = todosState.pendingTodos
                  .where((todo) => !items.any((item) => item.todo == todo.id))
                  .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: todosState.pendingTodos.length,
                  itemBuilder: (context, index) {
                    final todo = todosState.pendingTodos[index];
                    return ListTile(
                      title: Text(todo.task),
                      onTap: () {
                        _showParetoValueDialog(context, todo);
                      },
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  void _showParetoValueDialog(BuildContext context, Todo todo) {
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add Pareto Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Value'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (valueController.text.isNotEmpty) {
                  int value = int.tryParse(valueController.text) ?? 0;
                  ParetoItem newItem = ParetoItem(
                    id: const Uuid().v4(),
                    todo: todo, // assign the entire Todo object
                    value: value,
                  );
                  context.read<ParetoBloc>().add(ParetoItemAdded(newItem));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ParetoInstructionsPanel extends StatefulWidget {
  const ParetoInstructionsPanel({Key? key}) : super(key: key);

  @override
  _ParetoInstructionsPanelState createState() => _ParetoInstructionsPanelState();
}

class _ParetoInstructionsPanelState extends State<ParetoInstructionsPanel> {
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
                title: Text('Pareto Instructions'),
              );
            },
            body: Column(
              children: const [
                ListTile(
                  title: Text('1. List problems you are facing.'),
                ),
                ListTile(
                  title: Text('2. Identify the root cause.'),
                ),
                ListTile(
                  title: Text('3. Assign a score to each problem.'),
                ),
                ListTile(
                  title: Text('4. Group problems together by cause.'),
                ),
                ListTile(
                  title: Text('5. Add up the score of each group.'),
                ),
                ListTile(
                  title: Text('6. Take action.'),
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
