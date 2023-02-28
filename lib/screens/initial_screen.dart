import 'package:flutter/material.dart';
import 'package:todoprocast_app/screens/add_todo_screen.dart';
import 'package:todoprocast_app/screens/home_screen.dart';
import 'package:todoprocast_app/services/settings.dart';

import '../services/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const AddTodoScreen(),
    const Profile(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GridView.builder(
          shrinkWrap: true,
          itemCount: _pages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  _pages[index],
                    ),
                  );
                },
                child: Card(
                  child: Center(
                    child: Text(_pages[index].toString()),
                  ),
                ),
              );
            }),
      ));
  }
}

