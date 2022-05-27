import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    ApiClient().getProfile().then((value) {
      context.read<Data>().refreshProfileData(value);

      switch (value.role) {
        case 'student':
          Navigator.popAndPushNamed(context, RoutesName.student);
          break;
        case 'teacher':
          Navigator.popAndPushNamed(context, RoutesName.teacher);
          break;
        case 'admin':
          Navigator.popAndPushNamed(context, RoutesName.teacher);
          break;
        default:
          Navigator.popAndPushNamed(context, RoutesName.login);
          break;
      }
    }).catchError((error, stackTrace) {
      if (error is NotLoginException)
        Navigator.popAndPushNamed(context, RoutesName.login);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: CircularProgressIndicator(),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
