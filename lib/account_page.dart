import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        title: Text(
          'EduDigital',
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Center(
              child: InkWell(
                child: Text("Выйти"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
      drawer: MediaQuery
          .of(context)
          .size
          .width < 700
          ? Drawer(
        child: Menu(),
      )
          : null,
      body: SafeArea(
        child: Center(
          child: MediaQuery
              .of(context)
              .size
              .width < 700
              ? ListView(children: [Greetings(), Content()])
              : Row(
            children: [
              Container(width: 200, child: Menu()),
              Container(
                width: (MediaQuery
                    .of(context)
                    .size
                    .width - 200) * 0.6,
                child: Content(),
              ),
              Container(
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 200) * 0.4,
                  child: Greetings())
            ],
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(context) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child:
        ListView(
          shrinkWrap: true,
          children: [1, 2, 3, 4].map((e) {
            return e != 4 ? EduProgressLevel(level: e, isOpen: e != 3) :
            MaterialButton(
              onPressed: () {},
              color: Theme
                  .of(context)
                  .accentColor,
              child: CustomText("Траектория"),
            );
          }).toList(),
        ),
      );
}

class Greetings extends StatelessWidget {
  @override
  Widget build(context) =>
      Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          color: Colors.blueGrey[50],
          shape: Border.all(color: Colors.blue),
          child: CustomText(
            Constants.lorem_ipsum.replaceAll('%name%', 'Анастасия Бочкарева'),
            color: Colors.black,
            padding: 5.0,
          ),
        ),
      );
}

class CustomText extends StatelessWidget {
  final String text;
  final double padding;
  final Color color;
  final double fontSize;

  @override
  Widget build(context) =>
      Padding(
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

class Menu extends StatelessWidget {
  @override
  Widget build(context) =>
      Container(
        color: Theme
            .of(context)
            .accentColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(child: Image.asset("background2.png")),
            ),
            ListView(children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CustomText("Мой профиль"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
              Center(
                child: CustomText(
                  "Анастасия Бочкарева",
                  fontSize: 16,
                ),
              ),
              Center(
                child: CustomText("Группа 001"),
              ),
              SizedBox(height: 100.0),
              MaterialButton(
                onPressed: () {},
                child: ListTile(
                  title: CustomText(
                    "Мои компетенции",
                    fontSize: 12,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: ListTile(
                  title: CustomText(
                    "Служба поддержки",
                    fontSize: 12,
                  ),
                ),
              )
            ]),
          ],
        ),
      );
}

class EduProgressLevel extends StatelessWidget {
  final int level;
  final bool isOpen;

  EduProgressLevel({required this.level, required this.isOpen});

  @override
  Widget build(context) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(children: [
          Row(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Expanded(
                child: Text(
                  "$level уровень",
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            if (isOpen)
              SizedBox()
            else
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Закрыт",
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
          ]),
          Divider(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: EduProgressIndicator(
                    progress: isOpen ? Random().nextInt(100) : 0),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: EduProgressIndicator(
                    progress: isOpen ? Random().nextInt(100) : 0),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: EduProgressIndicator(
                    progress: isOpen ? Random().nextInt(100) : 0),
              ),
            ],
          ),
        ]),
      );
}

class EduProgressIndicator extends StatelessWidget {
  final int progress;

  EduProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Row(children: [
        Expanded(
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor:
            AlwaysStoppedAnimation<Color>(checkColor(this.progress)),
            value: this.progress / 100,
          ),
        ),
        Padding(padding: EdgeInsets.all(5.0), child: Text('${this.progress}%'))
      ]),
    );
  }

  Color checkColor(int progress) {
    if (progress <= 30)
      return Colors.red;
    else if (progress > 30 && progress <= 60)
      return Colors.yellow;
    else if (progress > 60)
      return Colors.green;
    else
      return Colors.grey;
  }
}
