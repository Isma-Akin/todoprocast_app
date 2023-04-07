import 'package:flutter/material.dart';

import 'package:todoprocast_app/constants.dart';



class GroupedTasksScreen extends StatefulWidget {
  const GroupedTasksScreen({Key? key}) : super(key: key);

  @override
  State<GroupedTasksScreen> createState() => _GroupedTasksScreenState();
}

class _GroupedTasksScreenState extends State<GroupedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: AppColors.tertiaryColor,
          title: const Text('Grouped Tasks'),
        ),
        body: Column(
          children: const [
            Card(
                child: Text('Grouped Tasks')),
          ],
        ),
      ),
    );
  }
}
