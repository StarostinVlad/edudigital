import 'dart:html';
import 'dart:ui' as ui;
import 'package:edudigital/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'EduDigital',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      backgroundColor: Colors.black54,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/background.jpg"),
          ),
        ),
        child: Center(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              width: MediaQuery.of(context).size.height * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: [
                    Text(
                      "Авторизация",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          focusColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(),
                          hintText: 'Введите логин',
                          icon: Icon(
                            Icons.account_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          focusColor: Theme.of(context).primaryColor,
                          border: OutlineInputBorder(),
                          icon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: 'Введите пароль',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Container(
                        width: double.infinity,
                        child: MaterialButton(
                          child: Text("Авторизоваться"),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pushNamed(context, "/account");
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
