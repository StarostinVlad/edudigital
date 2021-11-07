import 'dart:ui' as ui;

import 'package:edudigital/constants.dart';
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
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              icon: Icon(Icons.account_circle),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black54,
      body: ListView(
        children: [
          Container(
            height: 500,
            // margin: EdgeInsets.only(bottom: 50.0),
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
                image: AssetImage("assets/background.jpg"),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/background.jpg"),
              ),
            ),
            child: Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 270,
                    height: 480,
                    margin: EdgeInsets.only(left: 50.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://image.shutterstock.com/image-photo/smiling-bearded-indian-businessman-working-600w-1945041148.jpg"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Column(children: [
                        Text(
                          "Блок о том что это такое",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Constants.lorem_ipsum,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Column(children: [
                      Text(
                        "Блок о том для кого это",
                        style: TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Constants.lorem_ipsum,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                  ),
                ),
                Container(
                  width: 270,
                  height: 480,
                  margin: EdgeInsets.only(right: 50.0),
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
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/background.jpg"),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 270,
                  height: 480,
                  margin: EdgeInsets.only(left: 50.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://image.shutterstock.com/image-photo/girl-hacker-digital-world-young-600w-1246145740.jpg"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Column(children: [
                      Text(
                        "Блок о том какая от этого польза",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        Constants.lorem_ipsum,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ]),
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
            color: Theme.of(context).accentColor,
            child: Column(children: [
              Text(
                "Какая-то информация о нас",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                Constants.lorem_ipsum,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
