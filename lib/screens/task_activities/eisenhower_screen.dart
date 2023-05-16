import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/screens/task_activities/eisenhower_page.dart';

class EisenHowerScreen extends StatefulWidget {
  const EisenHowerScreen({Key? key}) : super(key: key);

  @override
  State<EisenHowerScreen> createState() => _EisenHowerScreenState();
}

class _EisenHowerScreenState extends State<EisenHowerScreen> {

  // void _applyEisenhower(List<Todo> todo) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => EisenhowerPage(todos: todo)),
  //   );
  // }

  // void _showEisenhowerModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BlocBuilder<TodosStatusBloc, TodosStatusState>(
  //         builder: (context, state) {
  //           if (state is TodosStatusLoaded) {
  //             final selectedTodos = <Todo>[];
  //             return StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setState) {
  //                 return Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: Text(
  //                         'Select Todos for Eisenhower Matrix',
  //                         style: Theme.of(context).textTheme.headline6,
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: ListView.builder(
  //                         itemCount: state.pendingTodos.length,
  //                         itemBuilder: (context, index) {
  //                           final todo = state.pendingTodos[index];
  //                           return CheckboxListTile(
  //                             title: Text(todo.task),
  //                             subtitle: Text(DateFormat.yMd().format(todo.deadline)),
  //                             value: selectedTodos.contains(todo),
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 if (value!) {
  //                                   selectedTodos.add(todo);
  //                                 } else {
  //                                   selectedTodos.remove(todo);
  //                                 }
  //                               });
  //                             },
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         ElevatedButton(
  //                           child: Text('Cancel'),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                         ),
  //                         ElevatedButton(
  //                           child: Text('Apply'),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                             _applyEisenhower(selectedTodos);
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           } else {
  //             return const CircularProgressIndicator();
  //           }
  //         },
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.navigate_before_rounded, size: 30,),
          ),
          flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/cloudbackground.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.indigo[900]?.withOpacity(0.6),
                  ),
                ],
              )
          ),
          centerTitle: true,
          title: Text(
            'Eisenhower Matrix',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Divider(
                height: 10,
                thickness: 2,
                color: Colors.indigo[900],),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/eisenhower.png'),
                              colorFilter: ColorFilter.mode(
                                Colors.orange.withOpacity(0.5),
                                BlendMode.dstATop,
                              ),
                              fit: BoxFit.contain,
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
                          color: Colors.indigo[900],),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.black,
                              ),
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Text(
                              'The Eisenhower Matrix is a method of '
                                  'prioritizing tasks by urgency and importance. \n'
                                  '1. Identify your tasks \n'
                                  '2. Classify your tasks \n'
                                  '3. Prioritize your tasks \n'
                                  '4. Do the tasks \n'
                                  '5. Review your tasks',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                height: 10,
                thickness: 0.5,
                color: Colors.grey[900],),
              Card(
                elevation: 2,
                child: InkWell(
                  highlightColor: Colors.blue[900],
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    // _showEisenhowerModal();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EisenhowerPage(),
                      ),
                    );
                  },
                  splashColor: Colors.blue[900],
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.zero,
                      child: Row(
                        children:  [
                          Icon(Icons.timer, color: Colors.indigo[900],),
                          const SizedBox(width: 10,),
                          Text('Eisenhower screen ', style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),],)
                  ),
                ),
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
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.zero,
                      child: Row(
                        children:  [
                          Icon(Icons.task_outlined, color: Colors.indigo[900],),
                          const SizedBox(width: 10,),
                          Text('Eisenhower information: ', style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),],)
                  ),
                ),
              ),
              // Card(
              //   elevation: 2,
              //   child: InkWell(
              //     highlightColor: Colors.blue[900],
              //     customBorder: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => EisenhowerPage(),
              //         ),
              //       );
              //     },
              //     splashColor: Colors.blue[900],
              //     child: Container(
              //         width: MediaQuery.of(context).size.width,
              //         height: 50,
              //         margin: EdgeInsets.zero,
              //         child: Row(
              //           children:  [
              //             Icon(Icons.info_outline, color: Colors.indigo[900],),
              //             const SizedBox(width: 10,),
              //             Text('Press to know more about Eisenhower', style: GoogleFonts.openSans(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold)),],)
              //     ),
              //   ),
              // ),
              Divider(
                height: 10,
                thickness: 0.5,
                color: Colors.grey[900],),
              const SizedBox(height: 10,),
              Card(
                elevation: 2,
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Text("Pomodoro",
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                ),
              ),
              Card(
                elevation: 2,
                child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Text("Eat that frog",
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                ),
              ),
              // BlocBuilder<TodosStatusBloc, TodosStatusState>(
              //   builder: (context, state) {
              //     if (state is TodosStatusLoading) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     if (state is TodosStatusLoaded) {
              //       return Expanded(
              //           child: ListView(children: [
              //             _todo(
              //               state.pendingTodos,
              //               ' ',
              //             )
              //           ]));
              //     } else {
              //       return const Text('Something went wrong.');
              //     }
              //   },
              // ),
            ],
          ),
        )

    );
  }
}