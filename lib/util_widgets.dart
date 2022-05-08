import 'dart:convert';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        'Edu-IT',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Center(
            child: InkWell(
              child: Text("Выйти"),
              onTap: () {
                ApiClient().logout();
                Navigator.popAndPushNamed(context, RoutesName.login);
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  ui.Size get preferredSize => Size.fromHeight(50);
}

showProfileImage(var user) {
  try {
    return user!.image.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.memory(
              base64Decode(user.image.toString()),
              errorBuilder: (context, error, stackTrace) {
                return NoAccountImage();
              },
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : throw Exception();
  } catch (exception) {
    return NoAccountImage();
  }
}

class NoAccountImage extends StatelessWidget {
  const NoAccountImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.asset(
        "assets/no_acc_image.jpg",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<Data>().getProfileData;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Center(
        child: Container(
          width: 55,
          height: 55,
          child: Stack(children: [
            InkWell(
              onTap: () {
                ApiClient().uploadImage().then((value) => ApiClient()
                    .getProfile()
                    .then((value) =>
                        context.read<Data>().refreshProfileData(value)));
              },
              child: showProfileImage(user),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  ApiClient().removeImage().then((value) => ApiClient()
                      .getProfile()
                      .then((value) =>
                          context.read<Data>().refreshProfileData(value)));
                },
                child: Icon(
                  Icons.cancel,
                  size: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double padding;
  final Color color;
  final double fontSize;

  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: fontSize),
        ),
      );

  CustomText(this.text,
      {this.padding = 0.0, this.color = Colors.white, this.fontSize = 14.0});
}

class Greetings extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          color: Colors.blueGrey[50],
          shape: Border.all(color: Colors.blue),
          child: CustomText(
            context.watch<Data>().getProfileData!.role == "teacher"
                ? Constants.greetings_for_teach
                    .replaceAll('%name%', context.watch<Data>().getFullname)
                : Constants.greetings_for_student
                    .replaceAll('%name%', context.watch<Data>().getFullname),
            color: Colors.black,
            padding: 5.0,
          ),
        ),
      );
}
