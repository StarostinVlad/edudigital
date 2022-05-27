import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'teacher_page.dart';
import 'main.dart';
import 'util_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: MyApp.isDesktop(context)
              ? Container(
                  padding: EdgeInsets.only(top: 50.0),
                  color: Theme.of(context).primaryColor,
                  child: Row(children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 0) * 0.6,
                      child: Column(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height) * 0.8,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: AssetImage(
                                      'assets/login_background.jpg',
                                    ))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextOnTopLoginPage(),
                                    TextOnLoginPage()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height:
                                  (MediaQuery.of(context).size.height) * 0.1,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                        'Проект разработан при поддержки Фонда содействия инновациям'),
                                    Container(
                                        height: 50.0,
                                        child: Image.asset('assets/found1.png'))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width - 0) * 0.4,
                        child: LoginContent())
                  ]),
                )
              : LoginContent(),
        ));
  }
}

class TextOnTopLoginPage extends StatelessWidget {
  const TextOnTopLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Container(height: 75.0, child: Image.asset('assets/EIKFU_logo.png')),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Казанский федеральный',
                fontSize: 20,
              ),
              CustomText(
                'УНИВЕРСИТЕТ',
                fontSize: 20,
              ),
              CustomText(
                'Елабужский институт',
                fontSize: 20,
              )
            ],
          ),
        ),
        Text(
          'EDU-IT',
          style: TextStyle(
              fontWeight: ui.FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 54),
        ),
      ]),
    );
  }
}

class TextOnLoginPage extends StatelessWidget {
  const TextOnLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Система оценки',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: ui.FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 48),
          ),
          Text(
            'цифровых компетенций',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: ui.FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 48),
          ),
          Text(
            'Онлайн-платформа для оценки и',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
          Text(
            'развития цифровой компетентности студентов педагогических направлений',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          ),
        ],
      ),
    );
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
            initialValue: 'user3_email@mail.ru',
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
        Flexible(
          child: TextButton(
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => ForgetPassword());
            },
            child: CustomText(
              'Забыли пароль?',
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          width: double.infinity,
          child: MaterialButton(
            height: 50.0,
            color: Theme.of(context).accentColor,
            child: CustomText("Войти"),
            onPressed: () {
              if (loginForm.currentState!.validate()) {
                loginForm.currentState!.save();
                setState(() {
                  _errorMsg = null; // clear any existing errors
                  _enabled = false;
                });
                print('$_login $_password');
                ApiClient().auth(_login!, _password!).then((loginValue) {
                  ApiClient().getProfile().then((profileValue) {
                    context.read<Data>().refreshProfileData(profileValue);
                    if (profileValue.role == 'student')
                      Navigator.popAndPushNamed(context, "/student");
                    if (profileValue.role == 'teacher') {
                      Navigator.popAndPushNamed(context, "/teacher");
                    }
                    if (profileValue.role == 'admin')
                      Navigator.popAndPushNamed(context, "/admin");
                    else
                      setState(() {
                        _enabled = true;
                        _errorMsg = "Неверный email или пароль";
                      });
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    _enabled = true;
                    _errorMsg = error.toString();
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
              ApiClient()
                  .forgetPassword(_emailController.text)
                  .onError(
                      (error, stackTrace) => _emailError = error.toString())
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
