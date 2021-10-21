import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'video.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'EduDigital',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 30.0),
            child: IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 40.0,
              onPressed: () {},
              icon: Icon(Icons.account_circle),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 500,
            margin: EdgeInsets.only(bottom: 50.0),
            child: Stack(children: [
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              VideoPlayerScreen(),
            ]),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://image.shutterstock.com/z/stock-photo-smiling-bearded-african-man-using-laptop-at-home-while-sitting-the-wooden-table-male-hands-typing-573112123.jpg"),
              ),
            ),
          ),
          Container(
            color: Colors.green,
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
            padding: EdgeInsets.symmetric(horizontal: 250.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 270,
                  height: 480,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://image.shutterstock.com/image-photo/smiling-bearded-indian-businessman-working-600w-1945041148.jpg"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Text(
                    "Блок о том что это такое",
                    style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
            padding: EdgeInsets.symmetric(horizontal: 250.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Text(
                    "Блок о том для кого это",
                    style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 270,
                  height: 480,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://image.shutterstock.com/z/stock-photo-pensive-male-graphic-designer-working-on-freelance-using-laptop-computer-and-wireless-internet-in-1456783418.jpg"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.green,
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
            padding: EdgeInsets.symmetric(horizontal: 250.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 270,
                  height: 480,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://image.shutterstock.com/image-photo/girl-hacker-digital-world-young-600w-1246145740.jpg"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Text(
                    "Блок о том какая от этого польза",
                    style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 2.0,
          ),
          Container(
            padding: EdgeInsets.all(50.0),
            child: Text(
              "Какая-то информация о нас",
              style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
