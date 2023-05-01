
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:intl/intl.dart';

import '../api/todo_repository.dart';
import '../blocs/todos/todos_bloc.dart';
import 'home_screen.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;

  const TodoDetailScreen({required this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late final SharedPreferences prefs;
  DateTime? _dueDate;
  bool _isChecked = false;
  bool _isExpanded = false;
  late final Todo todo;
  late final TodosBloc todosBloc;
  late final TextEditingController _descriptionController;
  late final TextEditingController _newStepController = TextEditingController();
  bool showSteps = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = value;
        // todosBloc = TodosBloc(TodoRepository(prefs: prefs), prefs);
      });
    });
    todo = widget.todo;
    _descriptionController = TextEditingController(text: widget.todo.description);
    _isChecked = widget.todo.taskCompleted ?? false;
    todosBloc = context.read<TodosBloc>();
  }


  void _pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (todo.dueDate != null) ? todo.dueDate : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime((todo.dueDate != null)
            ? todo.dueDate: DateTime.now()),
      );

      if (time != null) {
        final DateTime newDueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        todosBloc.add(
          UpdateDueDateEvent(
            todo: todo, // pass in the current todo here
            dueDate: newDueDate,
          ),
        );
      }
    }
  }

  void updateTodoDueDate(DateTime? newDueDate) {
    setState(() {
      _dueDate = newDueDate;
    });
    final updatedTodo = todo.copyWith(dueDate: newDueDate);
    todosBloc.add(UpdateDueDateEvent(todo: updatedTodo, dueDate: newDueDate));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _formKey.currentState?.save();
    super.dispose();
  }

  void _updateTodoDescription(String newDescription) {
    final updatedTodo = todo.copyWith(description: newDescription);
    todosBloc.add(UpdateTodo(todo: updatedTodo));
  }

  void _updateTodoSteps(List<String> newSteps) {
    final updatedTodo = todo.copyWith(steps: newSteps);
    todosBloc.add(UpdateTodo(todo: updatedTodo));
  }

  void _showDeleteTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodosBloc>().add(
                  RemoveTodo(
                    todo: todo.copyWith(taskCancelled: true),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  HomeScreen(todosBloc: context.read<TodosBloc>()),
                  ),
                );
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }


  DateTime now = DateTime.now();

  String getFormattedDate() {
    return DateFormat('dd-MM-yyyy – kk:mm').format(todo.dateCreated);
  }

  String formattedDueDate = DateFormat('yyyy-MM-dd – kk:mm').format(
      DateTime.now());
  final List<String> _newSteps = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _stepController = TextEditingController();

  void _showEditStepDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Step'),
          content: TextFormField(
            controller: TextEditingController(text: widget.todo.steps[index]),
            decoration: InputDecoration(
              labelText: 'Step ${index + 1}',
              border: const OutlineInputBorder(),
            ),
            onSaved: (newValue) {
              setState(() {
                widget.todo.steps[index] = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a step';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                }
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: todosBloc,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blueTertiaryColor,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.table_rows_rounded, color: AppColors.blueTertiaryColor,),
              onPressed: () {

              }
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.todo.task,
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 1,),
                    const Icon(Icons.book_online_rounded, color: Colors.grey,),
                    SizedBox(width: 10,),
                    SizedBox(
                      height: 50,
                      width: 330,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.1, 0, 20, 0),
                        child: Row(
                          children: [
                            SizedBox(width: 1,),
                            Expanded(
                              child: TextFormField(
                                onSaved: (value) {
                                  final updatedTodo = widget.todo.copyWith(description: value);
                                  context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                                },
                                controller: _descriptionController,
                                style: GoogleFonts.openSans(fontSize: 18),
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                ),
                                onChanged: _updateTodoDescription,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.1, 0, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 1),
                      Icon(Icons.lightbulb_outline_rounded, color: Colors.grey,),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickDueDate,
                          child: Text(
                            'Due Date: ${todo.formattedDueDate}',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 1,),
                    const Icon(Icons.airplay, color: Colors.grey,),
                    SizedBox(width: 10,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.1, 0, 69, 0),
                      child: Text(
                        'Current task activity applied: ',
                        style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,
                ),
                Row(
                  children: [
                    TextButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.todo.steps.add(_newStepController.text);
                          _newStepController.clear();
                        });
                        _updateTodoSteps([...widget.todo.steps, ..._newSteps]);
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _newStepController,
                        decoration: const InputDecoration(
                          hintText: "Add a new step",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: showSteps ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        setState(() {
                          showSteps = !showSteps;
                        });
                      },
                    ),
                  ],
                ),
                  if (showSteps)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue,width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SizedBox(
                      height: 180,
                      child: BlocBuilder<TodosBloc, TodosState>(
                        builder: (context, state) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.todo.steps.length +
                                  _newSteps.length,
                              itemBuilder: (context, index) {
                                if (index < widget.todo.steps.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Text("Step ${index + 1}",
                                          style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,),),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child:
                                          Text(widget.todo.steps[index],
                                            style: const TextStyle(fontSize: 18),),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _showEditStepDialog(context, index);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              widget.todo.steps.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  final stepIndex = index -
                                      widget.todo.steps.length;
                                  return Row(
                                    children: [
                                      Text("Step ${index + 1}"),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child:
                                        Text(_newSteps[stepIndex],
                                          style: const TextStyle(fontSize: 18),),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditStepDialog(context, index);
                                        },
                                      ),
                                      IconButton(icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _newSteps.removeAt(stepIndex);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                              });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Column(
                    children: [
                      Row(
                        children: [
                          // Text('Mark as complete', style: GoogleFonts.openSans(fontSize: 24),),
                          GestureDetector(
                            onTap: () {
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Card(
                                child: Container(
                                  decoration: const BoxDecoration(
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("Add file", style: GoogleFonts.openSans(fontSize: 13),),
                                      ),
                                      Icon(Icons.attach_file_rounded, color: Colors.blue, size: 50,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Complete?", style: GoogleFonts.openSans(fontSize: 13),),
                                    LikeButton(
                                      isLiked: todo.taskCompleted ?? false,
                                      onTap: (isLiked) {
                                        final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                                        context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                                        return Future.value(!isLiked);
                                      },
                                      size: 50,
                                      circleColor: const CircleColor(
                                        start: Colors.green,
                                        end: Colors.greenAccent,
                                      ),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.green,
                                        dotSecondaryColor: Colors.lightGreen,
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          isLiked ? Icons.check_box : Icons.check_box_outline_blank,
                                          color: isLiked ? Colors.green : Colors.black,
                                          size: 50,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: InkWell(
                                onTap: () {
                                  _showDeleteTodoDialog(context);
                                },
                                child: Card(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text("Delete task", style: GoogleFonts.openSans(fontSize: 13),),
                                        ),
                                        Icon(Icons.delete_forever, color: Colors.red, size: 50,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Form(
                  //     key: _formKey,
                  //     child: Row(
                  //         children: [
                  //           const Icon(Icons.add, color: Colors.grey, size: 40,),
                  //           Expanded(
                  //               child: TextFormField(
                  //                 controller: _stepController,
                  //                 decoration: const InputDecoration(
                  //                   labelText: 'Add a step',
                  //                   border: OutlineInputBorder(),
                  //                 ),
                  //                 validator: (value) {
                  //                   if (value == null || value.isEmpty) {
                  //                     return 'Please enter a step';
                  //                   }
                  //                   return null;
                  //                 },
                  //               )
                  //           )
                  //         ]
                  //     )),
                  const SizedBox(height: 0.5,),
                  // Padding(
                  //   padding: const EdgeInsets.all(35.0),
                  //   child: SizedBox(width: double.infinity,
                  //     height: 40,
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: AppColors.blueTertiaryColor,
                  //       ),
                  //       child: const Text('Add Step'),
                  //       onPressed: () {
                  //         if (_formKey.currentState!.validate()) {
                  //           setState(() {
                  //             _newSteps.add(_stepController.text);
                  //             _stepController.clear();
                  //           });
                  //         }
                  //         _updateTodoSteps([...widget.todo.steps, ..._newSteps]);
                  //       },
                  //     ),
                  //   ),
                  // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // const Icon(Icons.date_range_rounded, color: Colors.grey,),
                      Text(
                        'Created: ${getFormattedDate()}',
                        style: GoogleFonts.openSans(fontSize: 18, ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
          ),
          ),
        ),
    );
  }
}