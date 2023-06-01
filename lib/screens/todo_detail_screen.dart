
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/models/todo_models.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../blocs/todos/todos_bloc.dart';
import 'task_planner_screen.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;

  const TodoDetailScreen({required this.todo});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> with TickerProviderStateMixin{
  late final SharedPreferences prefs;
  DateTime? _dueDate;
  bool _isChecked = false;
  bool _isExpanded = false;
  late final Todo todo;
  late final TodosBloc todosBloc;
  late final TextEditingController _descriptionController;
  late final TextEditingController _newStepController = TextEditingController();
  bool showSteps = false;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _fontSizeAnimation;
  late Animation<double> _iconSizeAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.red,
    ).animate(_animationController);

    _fontSizeAnimation = Tween<double>(
      begin: 18,
      end: 20,
    ).animate(_animationController);

    _dueDate = widget.todo.dueDate;
    if (_dueDate != null &&
        _dueDate!.difference(DateTime.now()).inDays <= 2) {
      _animationController.repeat(reverse: true);
    }

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
      initialDate: todo.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime((todo.dueDate != null)
            ? todo.dueDate!
            : DateTime.now()),
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
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
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
                    builder: (context) =>  TaskPlanner(todosBloc: context.read<TodosBloc>()),
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
        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                image: const AssetImage('assets/images/cloudbackground.jpg'),
                fit: BoxFit.cover,
              ),
              border: const Border(
                top: BorderSide(width: 1.0, color: Colors.black),
              )
            ),
            // color: AppColors.bluePrimaryColor,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 2,),
                LikeButton(
                  isLiked: todo.taskCompleted ?? false,
                  onTap: (isLiked) {
                    final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                    context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                    return Future.value(!isLiked);
                  },
                  size: 23,
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
                      size: 23,
                    );
                  },
                ),
                const SizedBox(width: 30,),
                Text(
                  'Created: ${getFormattedDate()}',
                  style: GoogleFonts.openSans(fontSize: 18, ),
                ),
              SizedBox(width: 2,),
              IconButton(
                splashColor: Colors.red[200],
                   highlightColor: Colors.red[200],
                   onPressed: () {
                    _showDeleteTodoDialog(context);
                    },
                    icon: const Icon(Icons.delete_forever,
                 color: Colors.red, size: 23,),
                ),
              ],
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.2,
                image: AssetImage('assets/images/cloudbackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before_rounded, size: 30,
              color: AppColors.blueTertiaryColor,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.table_rows_rounded,
                color: AppColors.blueTertiaryColor,),
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
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white70,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.grey, thickness: 1,),
                    Hero(
                      tag: widget.todo.id,
                      child: Card(
                        elevation: 2,
                        child: GestureDetector(
                          onTap: _toggleExpandedState,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            width: MediaQuery.of(context).size.width,
                            // height: _isExpanded ? MediaQuery.of(context).size.height : 150,
                            height: _isExpanded ? 200 : 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: _isExpanded
                                ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                onChanged: _updateTodoDescription,
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Press here to add a description',
                                  hintStyle:
                                  GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: Colors.white),
                                  focusedBorder: InputBorder.none,
                                ),
                                autofocus: true,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                textAlignVertical: TextAlignVertical.top,
                                onEditingComplete: () {
                                  _toggleExpandedState();
                                },
                                onSubmitted: (value) {
                                  final updatedTodo =
                                  widget.todo.copyWith(description: value);
                                  context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                                  _toggleExpandedState();
                                },
                              ),
                            )
                                : Text(
                                  widget.todo.description.isNotEmpty
                                      ? widget.todo.description
                                      : 'Press here to add a description',
                                  style: GoogleFonts.openSans(
                                      fontSize: 18, color: Colors.black),
                                ),
                          ),
                        ),
                      ),
                    ),
                  // Expanded(
                    //   child: TextFormField(
                    //     maxLines: 5,
                    //     onSaved: (value) {
                    //       final updatedTodo = widget.todo.copyWith(description: value);
                    //       context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                    //     },
                    //     controller: _descriptionController,
                    //     style: GoogleFonts.openSans(fontSize: 18, color: Colors.white),
                    //     decoration: const InputDecoration(
                    //       labelText: 'Description', labelStyle: TextStyle(color: Colors.white),
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10,),
                    //     ),
                    //     onChanged: _updateTodoDescription,
                    //   ),
                    // ),
                    const Divider(thickness: 3),
                    const SizedBox(height: 5,),
                    Card(
                      elevation: 2,
                      child: InkWell(
                        highlightColor: Colors.blue[900],
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: _pickDueDate,
                        splashColor: Colors.blue[900],
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: EdgeInsets.zero,
                            child: Row(
                              children:  [
                                Icon(Icons.lightbulb_outline_rounded,
                                  color: Colors.blue[900],),
                                const SizedBox(width: 10,),
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Text(
                                      'Due date: ${todo.formattedDueDate}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _colorAnimation.value,
                                      ),
                              );
                            },
                          ),
                              ],
                            )
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      child: BlocBuilder<TodosBloc, TodosState>(
                        builder: (context, state) {
                          if (state is TodosLoaded) {
                            return InkWell(
                              highlightColor: Colors.blue[900],
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final todo = state.todos.firstWhere((todo) => todo.id == widget.todo.id);
                                    return SimpleDialog(
                                      title: const Text('Task activities'),
                                      children: todo.getTaskActivities().map((activity) {
                                        return SimpleDialogOption(
                                          child: Text(activity),
                                          onPressed: () {
                                            Navigator.pop(context, activity);
                                          },
                                        );
                                      }).toList(),
                                    );
                                  },
                                );

                              },
                              splashColor: Colors.blue[900],
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  margin: EdgeInsets.zero,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.airplay,
                                        color: Colors.blue[900],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      BlocBuilder<TodosBloc, TodosState>(
                                        builder: (context, state) {
                                          if (state is TodosLoaded) {
                                            final todo = state.todos.firstWhere((todo) => todo.id == widget.todo.id);

                                            List<String> taskActivities = todo.getTaskActivities();
                                            String displayText;
                                            if (taskActivities.isEmpty) {
                                              displayText = 'No task activity';
                                            } else {
                                              displayText = taskActivities.join(', ');
                                            }

                                            return Text(
                                                'Task activity: $displayText',
                                                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)
                                            );
                                          } else {
                                            return const Text('');
                                          }
                                        },
                                      )
                                      ,
                                    ],
                                  )),
                            );
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    Card(
                      elevation: 2,
                      child: InkWell(
                        highlightColor: Colors.blue[900],
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();

                          if(result != null) {
                            PlatformFile file = result.files.first;

                            print("File name: " + file.name);
                            print("File size: " + file.size.toString());
                            // print("File path: " + file.path);

                          } else {
                            // User canceled the picker
                          }
                        },
                        splashColor: Colors.blue[900],
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: EdgeInsets.zero,
                            child: Row(
                              children:  [
                                Icon(Icons.attach_file, color: Colors.blue[900],),
                                const SizedBox(width: 10,),
                                Text('Add a file: ', style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),],)
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,
                    ),
                    Card(
                      elevation: 2,
                      child: InkWell(
                        highlightColor: Colors.blue[900],
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {},
                        splashColor: Colors.blue[900],
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        widget.todo.steps.add(_newStepController.text);
                                        _newStepController.clear();
                                      });
                                      _updateTodoSteps(widget.todo.steps);
                                    },
                                    textInputAction: TextInputAction.done,
                                    style: GoogleFonts.openSans(fontSize: 20),
                                    controller: _newStepController,
                                    decoration: const InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      label: Text(
                                        'Add a new step',
                                        style: TextStyle(color: AppColors.blueTertiaryColor),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.add,
                                        color: AppColors.blueSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: showSteps ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    setState(() {
                                      showSteps = !showSteps;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (showSteps)
                              SingleChildScrollView(
                                child: Column(
                                  children: widget.todo.steps.asMap().map((index, step) {
                                    return MapEntry(
                                      index,
                                        Dismissible(
                                          key: ValueKey(step),
                                          onDismissed: (direction) {
                                            setState(() {
                                              widget.todo.steps.removeAt(index);
                                            });
                                            _updateTodoSteps(widget.todo.steps);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Step ${index + 1}: $step',
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 18),),
                                              ],
                                            ),
                                          ),
                                          background: Container(
                                            color: Colors.red,
                                            child: const ListTile(
                                              leading: Icon(Icons.delete, color: Colors.white),
                                              trailing: Icon(Icons.delete, color: Colors.white),
                                            ),
                                          ),
                                          secondaryBackground: Container(
                                            color: Colors.red,
                                            child: const ListTile(
                                              leading: Icon(Icons.delete, color: Colors.white),
                                              trailing: Icon(Icons.delete, color: Colors.white),
                                            ),
                                          ),
                                          confirmDismiss: (direction) async {
                                            if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart) {
                                              return await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Confirm"),
                                                    content: const Text("Are you sure you want to delete this step?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(true),
                                                        child: const Text("DELETE"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: const Text("CANCEL"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                            return false;
                                          },
                                          // Add the edit and delete buttons to the secondaryBackground widget tree
                                        ),
                                    );
                                  }).values.toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                      const SizedBox(height: 20,),
                      // Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         // Text('Mark as complete', style: GoogleFonts.openSans(fontSize: 24),),
                      //         GestureDetector(
                      //           onTap: () {
                      //           },
                      //           child: SizedBox(
                      //             height: 100,
                      //             width: 100,
                      //             child: Card(
                      //               child: Container(
                      //                 decoration: const BoxDecoration(
                      //                 ),
                      //                 child: Column(
                      //                   children: [
                      //                     Padding(
                      //                       padding: const EdgeInsets.all(10.0),
                      //                       child: Text("Add file", style: GoogleFonts.openSans(fontSize: 13),),
                      //                     ),
                      //                     const Icon(Icons.attach_file_rounded, color: Colors.blue, size: 50,),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 100,
                      //           width: 100,
                      //           child: Card(
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                      //                 children: [
                      //                   Text("Complete?", style: GoogleFonts.openSans(fontSize: 13),),
                      //                   LikeButton(
                      //                     isLiked: todo.taskCompleted ?? false,
                      //                     onTap: (isLiked) {
                      //                       final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                      //                       context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                      //                       return Future.value(!isLiked);
                      //                     },
                      //                     size: 50,
                      //                     circleColor: const CircleColor(
                      //                       start: Colors.green,
                      //                       end: Colors.greenAccent,
                      //                     ),
                      //                     bubblesColor: const BubblesColor(
                      //                       dotPrimaryColor: Colors.green,
                      //                       dotSecondaryColor: Colors.lightGreen,
                      //                     ),
                      //                     likeBuilder: (bool isLiked) {
                      //                       return Icon(
                      //                         isLiked ? Icons.check_box : Icons.check_box_outline_blank,
                      //                         color: isLiked ? Colors.green : Colors.black,
                      //                         size: 50,
                      //                       );
                      //                     },
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
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
                      // const SizedBox(height: 0.5,),
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
                    ],
                  ),
              ),
              ),
          ),
        ),
        ),
    );
  }
}

//     Row(
//   children: [
//     Expanded(
//       // child: TextFormField(
//       //   onFieldSubmitted: (value) {
//       //     setState(() {
//       //       widget.todo.steps.add(_newStepController.text);
//       //       _newStepController.clear();
//       //     });
//       //     _updateTodoSteps([...widget.todo.steps, ..._newSteps]);
//       //   },
//       //   controller: _newStepController,
//       //   decoration: const InputDecoration(
//       //     prefixIcon: Icon(Icons.add,
//       //       color: AppColors.blueSecondaryColor,),
//       //     hintText: "Add a new step",
//       //   ),
//       // ),
//       child: TextFormField(
//         onFieldSubmitted: (value) {
//           setState(() {
//             widget.todo.steps.add(_newStepController.text);
//             _newStepController.clear();
//           });
//           _updateTodoSteps([...widget.todo.steps, ..._newSteps]);
//
//         },
//         textInputAction: TextInputAction.done,
//         style: GoogleFonts.openSans(
//             fontSize: 20),
//         controller: _newStepController,
//         decoration: const InputDecoration(
//           label: Text('Add a new step',
//             style: TextStyle(color: AppColors.blueTertiaryColor),),
//           prefixIcon: Icon(Icons.add,
//             color: AppColors.blueSecondaryColor,),
//           // hintText: "Add mini task",
//         ),
//       ),
//     ),
//     IconButton(
//       icon: showSteps ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
//       onPressed: () {
//         setState(() {
//           showSteps = !showSteps;
//         });
//       },
//     ),
//   ],
// ),
//   if (showSteps)
//   Container(
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.blue, width: 2),
//       borderRadius: BorderRadius.circular(5),
//     ),
//     child: SizedBox(
//       height: 180,
//       child: BlocBuilder<TodosBloc, TodosState>(
//         builder: (context, state) {
//           return ListView.builder(
//               shrinkWrap: true,
//               itemCount: widget.todo.steps.length +
//                   _newSteps.length,
//               itemBuilder: (context, index) {
//                 if (index < widget.todo.steps.length) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Container(
//                       color: Colors.grey[200],
//                       child: Row(
//                         children: [
//                           Text("Step ${index + 1}",
//                             style: GoogleFonts.openSans(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,),),
//                           const SizedBox(width: 10,),
//                           Expanded(
//                             child: Text(widget.todo.steps[index],
//                               style: const TextStyle(fontSize: 18),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () {
//                               _showEditStepDialog(context, index);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               setState(() {
//                                 widget.todo.steps.removeAt(index);
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   final stepIndex = index -
//                       widget.todo.steps.length;
//                   return Row(
//                     children: [
//                       Text("Step ${index + 1}"),
//                       const SizedBox(width: 10,),
//                       Expanded(
//                         child:
//                         Text(_newSteps[stepIndex],
//                           style: const TextStyle(fontSize: 18),),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () {
//                           _showEditStepDialog(context, index);
//                         },
//                       ),
//                       IconButton(icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           setState(() {
//                             _newSteps.removeAt(stepIndex);
//                           });
//                         },
//                       ),
//                     ],
//                   );
//                 }
//               });
//         },
//       ),
//     ),
//   ),