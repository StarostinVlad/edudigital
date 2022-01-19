import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/login_page.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        'EduDigital',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Center(
            child: InkWell(
              child: Text("Выйти"),
              onTap: () {
                // UserAgentClient.logout();
                // print(UserAgentClient.available());
                Navigator.popAndPushNamed(context, RoutesName.home);
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  ui.Size get preferredSize => Size.fromHeight(height);
}

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: MediaQuery.of(context).size.width < 700
          ? Drawer(
              child: TeacherMenu(),
            )
          : null,
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 700
            ? Row(
                children: [
                  Container(width: 200, child: TeacherMenu()),
                  Flexible(
                    child: Column(
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          minWidth: double.infinity,
                          color: Colors.deepPurple,
                          child: CustomText(
                            'Инструкция к работе',
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: TeacherContent()),
                              Flexible(child: GroupsList()),
                              Flexible(child: Greetings()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : ListView(children: [Greetings(), TeacherContent(), GroupsList()]),
      ),
    );
  }
}

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: MediaQuery.of(context).size.width < 700
          ? Drawer(child: Menu())
          : null,
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 700
            ? Row(
              children: [
                Container(width: 200, child: Menu()),
                Flexible(
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        minWidth: double.infinity,
                        color: Colors.deepPurple,
                        child: CustomText(
                          'SoftSkills',
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                                width: (MediaQuery.of(context).size.width -
                                        200) *
                                    0.5,
                                child: StudentContent()),
                            Container(
                                width: (MediaQuery.of(context).size.width -
                                        200) *
                                    0.5,
                                child: Greetings())
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            : ListView(children: [Greetings(), StudentContent()]),
      ),
    );
  }
}

class Recomendation extends StatelessWidget {
  const Recomendation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 200,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                side: BorderSide(width: 2, color: Colors.purple)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '(Здесь сообщение от преподавателя)',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                side: BorderSide(width: 2, color: Colors.purple)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '(Здесь сообщение от преподавателя)',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        Container(
          height: 200,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                side: BorderSide(width: 2, color: Colors.purple)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '(Здесь сообщение от преподавателя)',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StudentTrajectoryScreen extends StatefulWidget {
  const StudentTrajectoryScreen({Key? key}) : super(key: key);

  @override
  _StudentTrajectoryScreenState createState() =>
      _StudentTrajectoryScreenState();
}

class _StudentTrajectoryScreenState extends State<StudentTrajectoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: MediaQuery.of(context).size.width < 700
          ? Drawer(
              child: Menu(),
            )
          : null,
      body: MediaQuery.of(context).size.width < 700
          ? ListView(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.purple,
                  child: CustomText(
                    'Траектория Развития',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                Flexible(child: StudentStatistic()),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: Menu()),
                Flexible(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.purple,
                        child: CustomText(
                          'Траектория Развития',
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: StudentStatistic(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({Key? key}) : super(key: key);

  @override
  _StudentDetailScreen createState() => _StudentDetailScreen();
}

class _StudentDetailScreen extends State<StudentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: MediaQuery.of(context).size.width < 700
          ? Drawer(
              child: TeacherMenu(),
            )
          : null,
      body: MediaQuery.of(context).size.width < 700
          ? TeacherStatistic()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: TeacherMenu()),
                Flexible(
                  child: Column(
                    children: [
                      Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.purple,
                          child: CustomText(
                            'Старостин Владислав Андреевич',
                            fontSize: 32,
                            color: Colors.white,
                          )),
                      Flexible(
                        child: TeacherStatistic(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class RecomendationDialog extends StatefulWidget {
  const RecomendationDialog({Key? key}) : super(key: key);

  @override
  _RecomendationDialogState createState() => _RecomendationDialogState();
}

class _RecomendationDialogState extends State<RecomendationDialog> {
  var _recomendationController = TextEditingController();

  String? _recomendationError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Форма подачи рекомендаций студенту')),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Оставьте рекомендаци по дальнейшей работе для студента(он увидит их в личном кабинете).'),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _recomendationController,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    errorText: _recomendationError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Рекомендаци по дальнейшей работе',
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
          child: const Text('Связаться с менеджером'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _recomendationError = null;
            });

            if (_recomendationController.text.isEmpty) {
              setState(() {
                _recomendationError = "Рекомендация не должна быть пустой";
              });
            }
            if (_recomendationError == null) {
              UserAgentClient.sendRecomendation(_recomendationController.text)
                  .then((value) => Navigator.pop(context, 'Отправить'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: MediaQuery.of(context).size.width < 700
          ? Drawer(
              child: Menu(),
            )
          : null,
      body: MediaQuery.of(context).size.width < 700
          ? Question()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: Menu()),
                Flexible(child: Question()),
              ],
            ),
    );
  }
}

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 50,
          width: double.infinity,
          color: Colors.purple,
          child: CustomText(
            'Тестирование первого уровня',
            fontSize: 32,
            color: Colors.white,
          )),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
            child: Text(
          'Тут какой то очень прикольный вопрос',
          style: Theme.of(context).textTheme.headline5,
        )),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '1. Тут какой-то первый вариант ответа',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '2. Здесь второй вариант ответа',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '3. Здесь третий',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      MaterialButton(
        color: Theme.of(context).accentColor,
        onPressed: () {},
        child: Text('Далее'),
      ),
    ]);
  }
}

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);

  @override
  _ChangeAvatarState createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();

  String? _nameError, _surnameError;

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать группу'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    errorText: _nameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Название группы',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    errorText: _surnameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Кол-во студентов',
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
              _nameError = null;
              _surnameError = null;
            });
            if (_nameController.text.length < 2) {
              setState(() {
                _nameError = "Имя должно быть не короче 2х символов";
              });
            }
            if (_surnameController.text.length < 2) {
              setState(() {
                _surnameError = "Фамилия должна быть не короче 2х символов";
              });
            }
            if (_surnameError == null && _nameError == null) {
              UserAgentClient.createGroup(
                      _nameController.text, _surnameController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class InviteStudent extends StatefulWidget {
  const InviteStudent({Key? key}) : super(key: key);

  @override
  _InviteStudentState createState() => _InviteStudentState();
}

class _InviteStudentState extends State<InviteStudent> {
  var _passwordController = TextEditingController();
  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();

  String? _emailError, _passwordError, _nameError, _surnameError;

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Пригласить студента'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    errorText: _nameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Введите имя студента',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    errorText: _surnameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Введите фамилию студента',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    errorText: _emailError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Введите email студента',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    errorText: _passwordError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Введите пароль студента',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _passwordController.text = getRandString(8);
                      },
                      icon: Icon(
                        Icons.cached_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
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
              _passwordError = null;
              _nameError = null;
              _surnameError = null;
            });
            if (!_emailController.text.isValidEmail()) {
              setState(() {
                _emailError = "Не корректный email";
              });
            }
            if (_passwordController.text.length < 8) {
              setState(() {
                _passwordError =
                    "Пароль должен содрежать не менее 8-ми символов";
              });
            }
            if (_nameController.text.length < 2) {
              setState(() {
                _nameError = "Имя должно быть не короче 2х символов";
              });
            }
            if (_surnameController.text.length < 2) {
              setState(() {
                _surnameError = "Фамилия должна быть не короче 2х символов";
              });
            }
            if (_emailError == null &&
                _passwordError == null &&
                _surnameError == null &&
                _nameError == null) {
              UserAgentClient.registry(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      _surnameController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class TeacherContent extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
            children: [1, 2, 3, 4]
                .map(
                  (e) => MaterialButton(
                    onPressed: () {
                      if (e == 1) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => InviteStudent());
                      } else {
                        Navigator.popAndPushNamed(context, RoutesName.detail);
                      }
                    },
                    child: e == 1
                        ? CustomText(
                            '+ Пригласить студента',
                            color: Colors.green,
                            padding: 15.0,
                            fontSize: 16.0,
                          )
                        : CustomText(
                            Constants.students[e - 2],
                            color: Colors.black,
                            padding: 15.0,
                            fontSize: 14.0,
                          ),
                  ),
                )
                .toList()),
      );
}

class StudentContent extends StatelessWidget {
  @override
  Widget build(context) => Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: ListView(
          shrinkWrap: true,
          children: [1, 2, 3, 4].map((e) {
            return e != 4
                ? EduProgressLevel(level: e, isOpen: e != 3)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, RoutesName.trajectory);
                      },
                      color: Theme.of(context).accentColor,
                      child: CustomText("Траектория"),
                    ),
                  );
          }).toList(),
        ),
      );
}

class GroupsList extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Группа 001',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Level(1),
          Level(2),
          Level(3),
        ]),
      );
}

class Level extends StatelessWidget {
  final int level;

  const Level(this.level, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        CustomText(
          'Уровень ${level - 1}',
          color: Colors.blue,
          fontSize: 16.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AccessLevel('1'),
              AccessLevel('2'),
              AccessLevel('3'),
            ],
          ),
        )
      ],
    ));
  }
}

class AccessLevel extends StatefulWidget {
  final String title;

  const AccessLevel(this.title, {Key? key}) : super(key: key);

  @override
  _AccessLevelState createState() => _AccessLevelState();
}

class _AccessLevelState extends State<AccessLevel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: MaterialButton(
        color: Theme.of(context).accentColor,
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AccessLevelDialog());
        },
        child: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AccessLevelDialog extends StatefulWidget {
  const AccessLevelDialog({Key? key}) : super(key: key);

  @override
  _AccessLevelDialogState createState() => _AccessLevelDialogState();
}

class _AccessLevelDialogState extends State<AccessLevelDialog> {
  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();

  String? _nameError, _surnameError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Предоставить доступ к уровню?'),
      content: Form(
        child: Text(''),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Отменить'),
        ),
        TextButton(
          onPressed: () {
            if (_surnameError == null && _nameError == null) {
              UserAgentClient.createGroup(
                      _nameController.text, _surnameController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('Предоставить'),
        ),
      ],
    );
  }
}

class Greetings extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          color: Colors.blueGrey[50],
          shape: Border.all(color: Colors.blue),
          child: CustomText(
            Constants.greetings_for_teach
                .replaceAll('%name%', 'Анастасия Бочкарева'),
            color: Colors.black,
            padding: 5.0,
          ),
        ),
      );
}

class TeacherStatistic extends StatelessWidget {
  const TeacherStatistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          TeacherStatisticItem(level: 1, isOpen: true),
          TeacherStatisticItem(level: 2, isOpen: true),
          TeacherStatisticItem(level: 3, isOpen: false),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: CustomText('Дать рекомендации студентам'),
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => RecomendationDialog());
                }),
          )
        ],
      ),
    );
  }
}

class StudentStatistic extends StatelessWidget {
  const StudentStatistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          Text(
            'Результаты по отдельным компетенциям',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          StudentStatisticItem(level: 1),
          StudentStatisticItem(level: 2),
          StudentStatisticItem(level: 3),
        ],
      ),
    );
  }
}

class StudentStatisticItem extends StatelessWidget {
  final int level;

  const StudentStatisticItem({Key? key, required this.level}) : super(key: key);

  children(context) {
    return [
      Flexible(
        flex: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$level уровень: 54% (Базовый)',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Table(
              border: TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.black, style: BorderStyle.solid)),
              children: [
                TableRow(
                    children:
                        row(context, type: 1, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 2, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 3, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 4, percent: Random().nextInt(100))),
              ],
            ),
          ],
        ),
      ),
      Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 5, color: Colors.deepPurple),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '(Здесь сообщение от преподавателя)',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  row(context, {required int type, required int percent}) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          type == 1
              ? 'Инициативность:'
              : type == 2
                  ? 'Коммуникативность:'
                  : type == 3
                      ? 'Технологические:'
                      : 'Ответственность:',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$percent%',
          textAlign: ui.TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          percent < 65
              ? 'Базовый'
              : percent > 80
                  ? 'Продвинутый'
                  : 'Средний',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.of(context).size.width <= 700
          ? ListView(
              shrinkWrap: true,
              children: children(context),
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children(context),
            ),
    );
  }
}

class TeacherStatisticItem extends StatelessWidget {
  final int level;
  final Map<String, double> levelStat = {
    "кв.1": 5,
    "кв.2": 3,
    "кв.3": 2,
    "кв.4": 2,
  };
  final bool isOpen;

  final List<Color> greyList = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];
  final List<Color> colorList = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent
  ];

  TeacherStatisticItem({Key? key, required this.level, required this.isOpen})
      : super(key: key);

  children(context) {
    return [
      Flexible(
        flex: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$level уровень: 54% (Базовый)',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Table(
              border: TableBorder(
                  verticalInside: BorderSide(
                      width: 1, color: Colors.black, style: BorderStyle.solid)),
              children: [
                TableRow(
                    children:
                        row(context, type: 1, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 2, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 3, percent: Random().nextInt(100))),
                TableRow(
                    children:
                        row(context, type: 4, percent: Random().nextInt(100))),
              ],
            ),
          ],
        ),
      ),
      Flexible(
          flex: 1,
          child: SizedBox(
            height: 250.0,
            width: 250.0,
            child: PieChart(
              dataMap: levelStat,
              colorList: isOpen ? colorList : greyList,
            ),
          )),
    ];
  }

  row(context, {required int type, required int percent}) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          type == 1
              ? 'Инициативность:'
              : type == 2
                  ? 'Коммуникативность:'
                  : type == 3
                      ? 'Технологические:'
                      : 'Ответственность:',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$percent%',
          textAlign: ui.TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          percent < 65
              ? 'Базовый'
              : percent > 80
                  ? 'Продвинутый'
                  : 'Средний',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.of(context).size.width <= 700
          ? ListView(
              shrinkWrap: true,
              children: children(context),
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children(context),
            ),
    );
  }
}

class Charts extends StatelessWidget {
  Map<String, double> level1 = {
    "кв.1": 5,
    "кв.2": 3,
    "кв.3": 2,
    "кв.4": 2,
  };
  Map<String, double> level2 = {
    "кв.1": 3,
    "кв.2": 2,
    "кв.3": 4,
    "кв.4": 3,
  };
  Map<String, double> level3 = {
    "кв.1": 3,
    "кв.2": 2,
    "кв.3": 4,
    "кв.4": 3,
  };

  @override
  Widget build(context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Уровень 1'),
          SizedBox(
            height: 200.0,
            width: 200.0,
            child: PieChart(dataMap: level1),
          ),
          Text('Уровень 2'),
          SizedBox(
            height: 200.0,
            width: 200.0,
            child: PieChart(dataMap: level2),
          ),
          Text('Уровень 3'),
          SizedBox(
            height: 200.0,
            width: 200.0,
            child: PieChart(dataMap: level3),
          ),
        ],
      );
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

class TeacherMenu extends StatefulWidget {
  @override
  State<TeacherMenu> createState() => _TeacherMenuState();
}

class _TeacherMenuState extends State<TeacherMenu> {
  String option1Text = "Мой профиль";

  @override
  Widget build(context) => Container(
        color: Theme.of(context).accentColor,
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
                  // child: CustomText("Мой профиль"),
                  child: CustomText(option1Text),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: IconButton(
                  onPressed: () {
                    UserAgentClient.uploadImage();
                    // showDialog<String>(
                    //     context: context,
                    //     builder: (BuildContext context) => ChangeAvatar());
                  },
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  "Анастасия Бочкарева",
                  fontSize: 16,
                  padding: 10.0,
                ),
              ),
              Center(
                child: ListView(shrinkWrap: true, children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, RoutesName.teacher);
                    },
                    child: ListTile(
                      title: CustomText(
                        "Группа 001",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, RoutesName.teacher);
                    },
                    child: ListTile(
                      title: CustomText(
                        "Группа 002",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CreateGroup());
                    },
                    child: ListTile(
                      title: CustomText(
                        "Создать группу",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ]),
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

class Menu extends StatelessWidget {
  @override
  Widget build(context) => Container(
        color: Theme.of(context).accentColor,
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
                onPressed: () {
                  UserAgentClient.available().then((value) => null);
                  Navigator.popAndPushNamed(context, RoutesName.student);
                },
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
  Widget build(context) => Padding(
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
    return MaterialButton(
      onPressed: () {
        Navigator.popAndPushNamed(context, RoutesName.testScreen);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(children: [
          Expanded(
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
              minHeight: 15,
              valueColor:
                  AlwaysStoppedAnimation<Color>(checkColor(this.progress)),
              value: this.progress / 100,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0), child: Text('${this.progress}%'))
        ]),
      ),
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
