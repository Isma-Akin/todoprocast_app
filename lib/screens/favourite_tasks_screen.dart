import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:todoprocast_app/blocs/blocs.dart';
import 'package:todoprocast_app/constants.dart';
import 'package:todoprocast_app/screens/todo_detail_screen.dart';

import '../blocs/groups/group_bloc.dart';
import '../blocs/groups/group_event.dart';
import '../blocs/groups/group_state.dart';
import '../models/group_models.dart';
import '../models/todo_models.dart';
import 'add_todo_screen.dart';
import 'grouped_page.dart';

class FavouriteTasksScreen extends StatefulWidget {
  const FavouriteTasksScreen({Key? key,}) : super(key: key);

  @override
  State<FavouriteTasksScreen> createState() => _FavouriteTasksScreenState();
}
enum TodoSortCriteria { dateCreated, alphabetically }

class _FavouriteTasksScreenState extends State<FavouriteTasksScreen> {
  final List<Todo> _todos = [];
  List<Group> groups = [] ;
  List<Todo> favouriteTasks = [];
  final TodoSortCriteria _sortCriteria = TodoSortCriteria.dateCreated;
  final TodoSortCriteria _sortCriteria2 = TodoSortCriteria.alphabetically;


  List<Todo> _sortTodos(List<Todo> todos) {
    switch (_sortCriteria) {
      case TodoSortCriteria.dateCreated:
        return todos..sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
      default:
        return todos..sort((a, b) => a.task.compareTo(b.task));
    }
  }

  void _addTodo(BuildContext contextbool, isFromFavouritesScreen) {
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
                child: AddTodoScreen(todosBloc: context.read<TodosBloc>(), isFromFavouritesScreen: isFromFavouritesScreen),
              ),
            ));
  }


  @override
  void initState() {
    super.initState();
    BlocProvider.of<GroupBloc>(context).add(LoadGroups());
    // BlocProvider.of<TodosBloc>(context).add(const LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              _addTodo(context, true);
            },
            child: const Icon(Icons.add, size: 30),
            elevation: 1,
          ),
          body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.settings,
                              color: Colors.lightGreenAccent,
                              size: 30,),
                            onPressed: () {
                              // Code to open settings
                            },
                          ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/cloudbackground.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Colors.green.withOpacity(0.6),
                                ),
                              ],
                            )
                        ),
                        backgroundColor: Colors.blue,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.home,
                            color: Colors.lightGreenAccent,
                            size: 30,
                          ),
                        ),
                        title: Center(
                            child: Text('Important Tasks',
                              style: GoogleFonts.openSans(
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),)),
                        floating: true,
                        snap: true,
                      ),
                      SliverToBoxAdapter(
                        child: BlocBuilder<TodosBloc, TodosState>(
                          builder: (context, state) {
                            if (state is TodosLoaded) {
                              final favouriteTodos = state.todos.where((todo) => todo.isFavourite ?? false).toList();
                              if (favouriteTodos.isEmpty) {
                                return Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 200,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text('No important tasks yet',
                                              style: TextStyle(fontSize: 30),),
                                            SizedBox(width: 10,),
                                            Icon(Icons.sticky_note_2)
                                          ],
                                        ),
                                        const SizedBox(height: 30,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text('Press + to add',
                                              style: TextStyle(fontSize: 30),),
                                            SizedBox(width: 10,),
                                          ],
                                        ),
                                      ],
                                    )
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height,  // Set height accordingly
                                          child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _sortTodos(favouriteTodos).length,
                                            itemBuilder: (context, index) {
                                              final todo = _sortTodos(favouriteTodos)[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0,
                                                    left: 3.0,
                                                    right: 3.0,
                                                    top: 8.0),
                                                child: _todosCard(context, todo),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      BlocBuilder<GroupBloc, GroupState>(
                                builder: (context, state) {
                                  if (state is GroupsLoaded) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.groups.length,
                                      itemBuilder: (context, index) {
                                        return GroupCard(
                                          group: state.groups[index],
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => GroupPage(
                                                    group: state.groups[index]),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else if (state is GroupsLoading) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return const Text('Something went wrong!');
                                  }
                                },
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                            return Center(
                            child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                             Text('Loading...', style: TextStyle(fontSize: 30),),
                             CircularProgressIndicator(color: Colors.orange,),
                        ],
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Dismissible _todosCard(
      BuildContext context,
      Todo todo,
      ) {

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        context.read<TodosBloc>().add(RemoveTodo(todo: todo.copyWith(taskCancelled: true),
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${todo.task} dismissed")),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
          image: DecorationImage(
            image: const AssetImage('assets/images/cloudbackground.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Card(
          color: AppColors.orangePrimaryColor,
          margin: const EdgeInsets.all(0.5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TodoDetailScreen(todo: todo,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<TodosBloc, TodosState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            todo.task,
                            style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.sticky_note_2_rounded, size: 20,),
                            onPressed: () async {
                              final selectedGroup = await showDialog<Group>(
                                context: context,
                                builder: (context) {
                                  return GroupDialog(
                                    groups: groups,
                                    onPressed: (Group) {  },);
                                },
                              );
                              if (selectedGroup != null) {
                                setState(() {
                                  selectedGroup.todos.add(todo);
                                });
                              }
                            },
                          ),
                          LikeButton(
                            isLiked: todo.isFavourite ?? false,
                            onTap: (isLiked) {
                              final updatedTodo = todo.copyWith(isFavourite: !isLiked);
                              context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                              return Future.value(!isLiked);
                            },
                            size: 35,
                            circleColor: const CircleColor(
                              start: Colors.yellow,
                              end: Colors.yellowAccent,
                            ),
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Colors.yellow,
                              dotSecondaryColor: Colors.yellow,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked ? Icons.star : Icons.star_outline_rounded,
                                color: isLiked ? Colors.yellow : Colors.white,
                                size: 35,
                              );
                            },
                          ),
                          // LikeButton(
                          //   isLiked: todo.isFavourite,
                          //   onTap: (isLiked) {
                          //     context.read<TodosBloc>().add(
                          //       MarkTodoAsFavOrUnFav(todo: todo),
                          //     );
                          //     return Future.value(!isLiked);
                          //   },
                          //   size: 25,
                          //   circleColor: const CircleColor(
                          //     start: Color(0xff00ddff),
                          //     end: Color(0xff0099cc),
                          //   ),
                          //   bubblesColor: const BubblesColor(
                          //     dotPrimaryColor: Color(0xff33b5e5),
                          //     dotSecondaryColor: Color(0xff0099cc),
                          //   ),
                          //   likeBuilder: (bool isLiked) {
                          //     return Icon(
                          //       isLiked ? Icons.star : Icons.star_border,
                          //       color: Colors.yellow,
                          //       size: 25,
                          //     );
                          //   },
                          // ),
                          LikeButton(
                            isLiked: todo.taskCompleted ?? false,
                            onTap: (isLiked) {
                              final updatedTodo = todo.copyWith(taskCompleted: !isLiked);
                              context.read<TodosBloc>().add(UpdateTodo(todo: updatedTodo));
                              return Future.value(!isLiked);
                            },
                            size: 35,
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
                                color: isLiked ? Colors.green : Colors.white,
                                size: 35,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.black,thickness: 2,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, color: Colors.grey,),
                      Text('Due date: ${todo.formattedDueDate}',
                        style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({Key? key, required this.group, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(group.name),
        ),
      ),
    );
  }
}

class GroupDialog extends StatefulWidget {
  final List<Group> groups;
  final Function(Group) onPressed;
  final Todo? todo;

  const GroupDialog({
    required this.groups,
    required this.onPressed,
    this.todo,
  });

  @override
  _GroupDialogState createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  late Group selectedGroup = Group(name: 'default', todos: []);
  final newGroupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.groups.isNotEmpty) {
      selectedGroup = widget.groups.first;
    } else {
      selectedGroup = Group(name: 'default', todos: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Group>(
            value: selectedGroup,
            onChanged: (Group? newValue) {
              setState(() {
                selectedGroup = newValue!;
              });
            },
            items: widget.groups.map<DropdownMenuItem<Group>>((Group group) {
              return DropdownMenuItem<Group>(
                value: group,
                child: Text(group.name),
              );
            }).toList(),
          ),
          TextField(
            controller: newGroupNameController,
            decoration: const InputDecoration(
              labelText: "New group's name",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            print("OK button pressed. Group name: ${newGroupNameController.text}");
            if (newGroupNameController.text.isNotEmpty) {
              print("Creating new group...");
              Group newGroup = Group(name: newGroupNameController.text, todos: []);
              widget.groups.add(newGroup);
              BlocProvider.of<GroupBloc>(context).add(AddGroup(newGroup));
              widget.onPressed(newGroup);
              if (widget.todo != null) {
                // BlocProvider.of<GroupBloc>(context).add(AddTodoToGroup(newGroup, widget.todo!));
              }
              Navigator.pop(context);
            } else {
              print("Updating existing group...");
              if (widget.todo != null) {
                // BlocProvider.of<GroupBloc>(context).add(AddTodoToGroup(selectedGroup, widget.todo!));
              }
              BlocProvider.of<GroupBloc>(context).add(AddGroup(selectedGroup));
              widget.onPressed(selectedGroup);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
