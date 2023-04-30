import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoprocast_app/constants.dart';

import 'package:todoprocast_app/logic/navigation/constants/nav_bar_items.dart';
import 'package:todoprocast_app/logic/navigation/navigation_cubit.dart';

import 'package:todoprocast_app/screens/home_screen.dart';
// import 'package:todoprocast_app/screens/profile_screen.dart';
// import 'package:todoprocast_app/screens/settings_screen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blueTertiaryColor,
            title: const Text('Settings'),
          ),
          body: const Center(
            child: Text('Settings'),
          ),
        );
      },
    );
  }
}


