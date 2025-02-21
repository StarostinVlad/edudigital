import 'package:edudigital/util_widgets.dart';
import 'package:flutter/material.dart';

class InviteStudentScreen extends StatefulWidget {
  final String groupId;

  const InviteStudentScreen({Key? key, required this.groupId})
      : super(key: key);

  @override
  _InviteStudentScreenState createState() => _InviteStudentScreenState();
}

class _InviteStudentScreenState extends State<InviteStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('Edu-it'),
      ),
      body: Container(
        child: Center(
          child: InviteStudent(),
        ),
      ),
    );
  }
}
