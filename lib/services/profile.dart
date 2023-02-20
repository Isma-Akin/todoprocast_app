import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:todoprocast_app/logic/navigation/constants/nav_bar_items.dart';
import 'package:todoprocast_app/logic/navigation/navigation_cubit.dart';

import 'package:todoprocast_app/screens/home_screen.dart';
// import 'package:todoprocast_app/screens/profile_screen.dart';
// import 'package:todoprocast_app/screens/settings_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: ((context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: const Center(
            child: Text('Profile'),
          ),
        );
      }),
    );
  }
}
