import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

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
                Navigator.popAndPushNamed(context, "/");
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
                        Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.purple,
                            child: CustomText(
                              'Инструкция к работе',
                              fontSize: 32,
                              color: Colors.white,
                            )),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                      width: (MediaQuery.of(context).size.width - 200) * 0.5,
                      child: StudentContent()),
                  Container(
                      width: (MediaQuery.of(context).size.width - 200) * 0.5,
                      child: Greetings())
                ],
              )
            : ListView(children: [Greetings(), StudentContent()]),
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
          ? ListView(
              children: [Flexible(child: StudentStatistic()), Charts()],
            )
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
                        child: Row(
                          children: [
                            Flexible(child: StudentStatistic()),
                            Charts()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
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
          child: const Text('Cancel'),
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
          child: const Text('Cancel'),
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
        child: ListView(
            shrinkWrap: true,
            children: [1, 2, 3, 4]
                .map(
                  (e) => MaterialButton(
                    onPressed: () {
                      if (e == 1) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => InviteStudent());
                      } else {
                        Navigator.popAndPushNamed(context, '/detail');
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
                      onPressed: () {},
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
        child: ListView(
            shrinkWrap: true,
            children: [1, 2, 3, 4]
                .map((e) => e == 1
                    ? CustomText(
                        'Группа 00$e',
                        color: Colors.black,
                        padding: 15.0,
                        fontSize: 18.0,
                      )
                    : Level(e))
                .toList()),
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
            children: [
              CustomText('1', padding: 5.0, color: Colors.black),
              Expanded(
                  child: CustomText('2', padding: 5.0, color: Colors.black)),
              CustomText('3', padding: 5.0, color: Colors.black),
            ],
          ),
        )
      ],
    ));
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

class StudentStatistic extends StatelessWidget {
  const StudentStatistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'Результаты по отдельным компетенциям',
            fontSize: 20,
            color: Colors.black,
          ),
          CustomText(
            '1 уровень: 54% (Базовый)',
            fontSize: 20,
            color: Colors.black,
          ),
          Text('Технологические: 72% Продвинутый'),
          Text('Коммуникационные: 83% Продвинутый'),
          Text('Инициативность: 60% Базовый'),
          Text('Ответственность: 60% Базовый'),
          CustomText(
            '2 уровень: 65% (Средний)',
            fontSize: 20,
            color: Colors.black,
          ),
          Text('Технологические: 72% Продвинутый'),
          Text('Коммуникационные: 83% Продвинутый'),
          Text('Инициативность: 60% Базовый'),
          Text('Ответственность: 60% Базовый'),
          CustomText(
            '3 уровень: 76% (Закрыт)',
            fontSize: 20,
            color: Colors.black,
          ),
          Text('Технологические: -'),
          Text('Коммуникационные: -'),
          Text('Инициативность: -'),
          Text('Ответственность: -'),
          MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text('Рекомендации студенту'),
              onPressed: () {})
        ],
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

  @override
  Widget build(context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Уровень 1'),
          SizedBox(
            height: 300.0,
            width: 300.0,
            child: PieChart(dataMap: level1),
          ),
          Text('Уровень 2'),
          SizedBox(
            height: 300.0,
            width: 300.0,
            child: PieChart(dataMap: level2),
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

class TeacherMenu extends StatelessWidget {
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
                  padding: 10.0,
                ),
              ),
              Center(
                child: ListView(shrinkWrap: true, children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/account");
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
                      Navigator.popAndPushNamed(context, "/account");
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
