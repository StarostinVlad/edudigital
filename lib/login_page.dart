import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_page.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.black54,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: MediaQuery.of(context).size.width >= 700
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  color: Theme.of(context).primaryColor,
                  child: Row(children: [
                    Container(
                        color: Colors.white,
                        width: (MediaQuery.of(context).size.width - 0) * 0.6,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: AssetImage(
                                            'login_background.jpg',
                                          ))),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Row(children: [
                                        Container(
                                            height: 50.0,
                                            child: Image.asset('found.png')),
                                        Expanded(
                                          child: CustomText(
                                              'Казанский федеральный университет\nЕлабужский институт'),
                                        ),
                                        CustomText(
                                          'EDU-IT',
                                          fontSize: 52,
                                        ),
                                      ]),
                                      SizedBox(
                                        height: 100,
                                      ),
                                      CustomText(
                                        'Система оценки цифровых компетенций',
                                        fontSize: 46,
                                      ),
                                      CustomText(
                                        'Онлайн-платформа для оценки и развития цифровой компетентности студентов педагогических направлений',
                                      ),
                                    ],
                                  ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                          'Проект разработан при поддержки Фонда содействия инновациям'),
                                      Container(
                                          height: 50.0,
                                          child: Image.asset('found.png'))
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 0) * 0.4,
                        child: LoginContent())
                  ]),
                )
              : LoginContent(),
        ));
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class LoginContent extends StatelessWidget {
  LoginContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      color: Colors.white,
      child: Column(
        children: [
          Align(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.demoScreen);
              },
              child: Text(
                'Курсы',
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
          Align(
            child: CustomText('Демо-версия системы оценки',
                color: Colors.blue, padding: 5.0),
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.height * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: LoginForm()),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? _errorMsg;
  final loginForm = GlobalKey<FormState>();

  String? _password;
  late bool _enabled, _isObscure = true;

  String? _login;

  @override
  void initState() {
    _enabled = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginForm,
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Авторизация",
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            enabled: _enabled,
            initialValue: 'user6_email@mail.ru',
            onSaved: (input) => _login = input,
            validator: (value) {
              if (value == null || value.isEmpty || !value.isValidEmail()) {
                return 'email должен быть корректным';
              }
              return null;
            },
            decoration: InputDecoration(
              focusColor: Theme.of(context).accentColor,
              border: OutlineInputBorder(),
              errorText: _errorMsg,
              hintText: 'Введите логин',
              suffixIcon: Icon(
                Icons.alternate_email,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            enabled: _enabled,
            initialValue: 'Aa111111',
            onSaved: (input) => _password = input,
            obscureText: _isObscure,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Пароль должен содержать не менее 8-ми символов';
              }
              return null;
            },
            decoration: InputDecoration(
              focusColor: Theme.of(context).accentColor,
              border: OutlineInputBorder(),
              errorText: _errorMsg,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).accentColor,
                ),
              ),
              hintText: 'Введите пароль',
            ),
          ),
        ),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              RememberMe(),
              TextButton(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => ForgetPassword());
                },
                child: CustomText(
                  'Забыли пароль?',
                  color: Theme.of(context).accentColor,
                ),
              )
            ])),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          width: double.infinity,
          child: MaterialButton(
            height: 50.0,
            color: Theme.of(context).accentColor,
            child: Text("Войти"),
            onPressed: () {
              if (loginForm.currentState!.validate()) {
                loginForm.currentState!.save();
                setState(() {
                  _errorMsg = null; // clear any existing errors
                  _enabled = false;
                });
                print('$_login $_password');
                // Constants.isStudent = Random().nextBool();
                // print(Constants.isStudent);
                // Navigator.popAndPushNamed(
                //     context,
                //     Constants.isStudent
                //         ? RoutesName.teacher
                //         : RoutesName.student);
                UserAgentClient.auth(_login!, _password!).then((value) {
                  print(value);
                  Constants.isStudent = false;
                  if (value=='Студент')
                    Navigator.popAndPushNamed(context, "/student");
                  if (value=='Учитель')
                    Navigator.popAndPushNamed(context, "/teacher");
                  if (value=='Администратор')
                    Navigator.popAndPushNamed(context, "/admin");
                  else
                    setState(() {
                      _enabled = true;
                      _errorMsg = "Неверный email или пароль";
                    });
                });
              }
            },
          ),
        ),
      ]),
    );
  }
}

class RememberMe extends StatefulWidget {
  const RememberMe({Key? key}) : super(key: key);

  @override
  _RememberMeState createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _checked,
          onChanged: (bool? value) {
            setState(() {
              _checked = !_checked;
            });
          },
        ),
        Text('Запомнить меня'),
      ],
    );
  }
}

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var _emailController = TextEditingController();

  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Забыли пароль?'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    errorText: _emailError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Введите email',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _emailError = null;
            });
            if (!_emailController.text.isValidEmail()) {
              setState(() {
                _emailError = "Не корректный email";
              });
            }
            if (_emailError == null) {
              UserAgentClient.forgetPassword(_emailController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
