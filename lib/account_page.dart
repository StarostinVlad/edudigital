import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/login_page.dart';
import 'package:edudigital/storage.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:timer_builder/timer_builder.dart';

import 'package:flutter/services.dart';

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
                UserAgentClient().logout();
                // print(UserAgentClient.available());
                Navigator.popAndPushNamed(context, RoutesName.login);
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
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: TeacherMenu(),
            )
          : null,
      body: SafeArea(
        child: MyApp.isDesktop(context)
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

  Future<List<LevelData>> _loadData() => UserAgentClient().available();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _loadData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<LevelData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData) {
            print('hasData: ${snapshot.hasData}');
            Provider.of<StudentStatisticData>(context)
                .refreshStatisticData(snapshot.data!);
          }
          if (snapshot.hasError) {
            print('snapshot.error: ${snapshot.error}');
            return LoadingError(
              onPressed: () {
                _loadData();
              },
            );
          }
          return StudentScreenLoaded();
        },
      );
}

class LoadingError extends StatelessWidget {
  final ui.VoidCallback? onPressed;

  const LoadingError({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(Constants.loadingProfileError),
          MaterialButton(
            onPressed: onPressed,
            child: Text(Constants.repeat),
          ),
        ],
      ),
    );
  }
}

class StudentScreenLoaded extends StatelessWidget {
  const StudentScreenLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 50,
      ),
      drawer: !MyApp.isDesktop(context) ? Drawer(child: Menu()) : null,
      body: SafeArea(
        child: MyApp.isDesktop(context)
            ? Row(
                children: [
                  Container(width: 200, child: Menu()),
                  Expanded(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex: 1,
                              child: StudentContent(),
                            ),
                            Flexible(
                              flex: 1,
                              child: Greetings(),
                            )
                          ],
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
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: Menu(),
            )
          : null,
      body: !MyApp.isDesktop(context)
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
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: TeacherMenu(),
            )
          : null,
      body: !MyApp.isDesktop(context)
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
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: Menu(),
            )
          : null,
      body: !MyApp.isDesktop(context)
          ? QuestionScreen()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: Menu()),
                Flexible(child: QuestionScreen()),
              ],
            ),
    );
  }
}

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  Timer? _timer;
  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    Repository().getEndTime().then((value) {
      timerMaxSeconds = value.difference(DateTime.now()).inSeconds;
      startTimeout();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.timer),
        SizedBox(
          width: 5,
        ),
        Text(timerText)
      ],
    );
  }
}

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Future<QuestionData> _question() => UserAgentClient().getNextQuestion();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpTimer(),
        FutureBuilder(
            future: _question(),
            builder: (context, AsyncSnapshot<QuestionData> snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error is TestIsOverException) {
                  print(snapshot.error);
                  Future.delayed(Duration(milliseconds: 200)).then((value) =>
                      Navigator.popAndPushNamed(context, RoutesName.student));
                }
                return LoadingError(onPressed: () {});
              }
              if (snapshot.connectionState != ConnectionState.done)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  print('snapshot: ${snapshot.data}');
                  var questionData = snapshot.data!;
                  Provider.of<Data>(context, listen: false)
                      .refreshQuestionData(questionData);
                  return Column(
                    children: [
                      QuestionContainer(questionData),
                      MaterialButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          UserAgentClient()
                              .giveAnswerForQuestion(
                                  questionData.id,
                                  Provider.of<Data>(context, listen: false)
                                      .getUserAnswerId)
                              .then((value) => setState(() {}));
                        },
                        child: Text('Далее'),
                      ),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }
}

class QuestionContainer extends StatelessWidget {
  final QuestionData _questionData;

  const QuestionContainer(this._questionData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 50,
          width: double.infinity,
          color: Colors.purple,
          child: CustomText(
            _questionData.title,
            fontSize: 32,
            color: Colors.white,
          )),
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
            child: Text(
          _questionData.body,
          style: Theme.of(context).textTheme.headline5,
        )),
      ),
      AnswersContainer(_questionData.answers!),
    ]);
  }
}

class AnswersContainer extends StatefulWidget {
  final List<AnswerData> _answers;

  const AnswersContainer(this._answers, {Key? key}) : super(key: key);

  @override
  State<AnswersContainer> createState() => _AnswersContainerState();
}

class _AnswersContainerState extends State<AnswersContainer> {
  var val;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget._answers.length,
      itemBuilder: (BuildContext context, int index) => Container(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Radio(
              value: index,
              groupValue: val,
              onChanged: (value) {
                Provider.of<Data>(context, listen: false)
                    .refreshUserAnswerId(widget._answers[index].id);
                setState(() {
                  val = value;
                });
              },
              activeColor: Colors.green,
            ),
            title: Text(
              widget._answers[index].body,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
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

  String? _nameError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать группу'),
      content: Form(
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
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _nameError = null;
            });
            if (_nameController.text.length < 2) {
              setState(() {
                _nameError = "Название должно быть не короче 2х символов";
              });
            }
            if (_nameError == null) {
              UserAgentClient().createGroup(_nameController.text).then((value) {
                Navigator.pop(context, 'OK');
                UserAgentClient().getGroups().then((value) {
                  if (value.isNotEmpty) {
                    context.read<GroupData>().refreshGroupsData(value);
                    UserAgentClient()
                        .getGroupDetail(value.first.id)
                        .then((groupDetail) {
                      context
                          .read<GroupData>()
                          .refreshGroupDetailData(groupDetail);
                    });
                  }
                });
              });
            }
          },
          child: const Text(Constants.create),
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

  Future<void> _copyToClipboard(String url) async {
    await Clipboard.setData(
        ClipboardData(text: "https://edu-it.online/#/invite/$url/"));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Пригласить студента'),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _copyToClipboard(Provider.of<GroupData>(context, listen: false)
                  .groupDetail!
                  .id);
            },
          )
        ],
      ),
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
              var groupDetail =
                  Provider.of<GroupData>(context, listen: false).groupDetail;
              print("groupId: ${groupDetail?.id}");
              UserAgentClient()
                  .registry(
                      groupDetail!.id,
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      _surnameController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            } else {
              print("another exception");
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
        child: Column(children: [
          MaterialButton(
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => InviteStudent());
              },
              child: CustomText(
                '+ Пригласить студента',
                color: Colors.green,
                padding: 15.0,
                fontSize: 16.0,
              )),
          memberList(context.watch<GroupData>().groupDetail?.members),
        ]),
      );

  memberList(List<User>? members) {
    if (members == null) return CircularProgressIndicator();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        return MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.detail);
            },
            child: ListTile(
              leading: Constants.showProfileImage(members[index]),
              title: CustomText(
                '${members[index].name} ${members[index].surname}',
                color: Colors.black,
                padding: 15.0,
                fontSize: 14.0,
              ),
            ));
      },
    );
  }
}

class StudentContent extends StatefulWidget {
  @override
  State<StudentContent> createState() => _StudentContentState();
}

class _StudentContentState extends State<StudentContent> {
  @override
  Widget build(context) => Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children:
                  Provider.of<StudentStatisticData>(context, listen: false)
                      .getStatisticData
                      .map((levelData) {
                print(levelData.name);
                return EduProgressLevel(level: levelData, isOpen: true);
                // Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 5.0),
                //     child: MaterialButton(
                //       onPressed: () {
                //         UserAgentClient().available().then((value) {
                //           print(value);
                //           Navigator.popAndPushNamed(
                //               context, RoutesName.trajectory);
                //         });
                //       },
                //       color: Theme.of(context).accentColor,
                //       child: CustomText("Траектория"),
                //     ),
                //   );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, RoutesName.trajectory);
              },
              child: Text(Constants.watchTrajectory),
            ),
          ],
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
              Provider.of<GroupData>(context, listen: false).groupDetail!.name,
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
            var groupDetail =
                Provider.of<GroupData>(context, listen: false).groupDetail;
            if (_surnameError == null && _nameError == null) {
              UserAgentClient()
                  .makeTestAvailable(groupDetail?.id, _surnameController.text)
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
      child: !MyApp.isDesktop(context)
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
      child: !MyApp.isDesktop(context)
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
              child: Container(child: Image.asset("assets/background2.png")),
            ),
            ListView(children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  // child: CustomText("Мой профиль"),
                  child: CustomText(option1Text),
                ),
              ),
              ProfileAvatar(),
              Center(
                child: CustomText(
                  context.watch<Data>().getFullname,
                  fontSize: 16,
                  padding: 10.0,
                ),
              ),
              groupsList(context.watch<GroupData>().groups),
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

  groupsList(List<Group> groups) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        return MaterialButton(
          onPressed: () {
            UserAgentClient()
                .getGroupDetail(groups[index].id)
                .then((groupDetail) {
              context.read<GroupData>().refreshGroupDetailData(groupDetail);
            });
          },
          child: ListTile(
            title: CustomText(
              groups[index].name,
              fontSize: 12,
            ),
          ),
        );
      },
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
                UserAgentClient().uploadImage().then((value) =>
                    UserAgentClient().getProfile().then((value) =>
                        context.read<Data>().refreshProfileData(value)));
              },
              child: Constants.showProfileImage(user),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  UserAgentClient().removeImage().then((value) =>
                      UserAgentClient().getProfile().then((value) =>
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

class Menu extends StatelessWidget {
  @override
  Widget build(context) => Container(
        color: Theme.of(context).accentColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(child: Image.asset("assets/background2.png")),
            ),
            ListView(children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: CustomText('Профиль'),
                ),
              ),
              ProfileAvatar(),
              Center(
                child: CustomText(
                  context.watch<Data>().getFullname,
                  fontSize: 16,
                ),
              ),
              Center(
                child: CustomText("${context.watch<Data>().getGroup}"),
              ),
              SizedBox(height: 100.0),
              MaterialButton(
                onPressed: () {
                  // UserAgentClient.available().then((value) => null);
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
  final LevelData level;
  final bool isOpen;

  EduProgressLevel({required this.level, required this.isOpen});

  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "${level.name}",
              textAlign: TextAlign.start,
            ),
            if (!isOpen)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Закрыт",
                  textAlign: TextAlign.end,
                ),
              ),
          ]),
          Divider(),
          Column(
            children: level.tests
                .map(
                  (test) => Padding(
                    padding: EdgeInsets.all(5.0),
                    child: EduProgressIndicator(test: test),
                  ),
                )
                .toList(),
          ),
        ]),
      );
}

class EduProgressIndicator extends StatelessWidget {
  final TestData test;

  EduProgressIndicator({required this.test});

  @override
  Widget build(BuildContext context) {
    // double progress = test.correct / test.total;
    double progress = test.total / 10;
    return MaterialButton(
      onPressed: test.available
          ? () {
              UserAgentClient()
                  .startTest(test.id)
                  .then((value) =>
                      Navigator.popAndPushNamed(context, RoutesName.testScreen))
                  .onError((error, stackTrace) {
                if (error is TestIsAlredyStartedException)
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AnotherTestAlreadyStartedDialog());
                else
                  Navigator.popAndPushNamed(context, RoutesName.student);
              });
            }
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(children: [
          Expanded(
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
              minHeight: 15,
              valueColor: AlwaysStoppedAnimation<Color>(checkColor(progress)),
              value: progress,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0), child: Text('${progress * 100}%'))
        ]),
      ),
    );
  }

  Color checkColor(double progress) {
    if (progress <= 0.3)
      return Colors.red;
    else if (progress > 0.3 && progress <= 0.6)
      return Colors.yellow;
    else if (progress > 0.6)
      return Colors.green;
    else
      return Colors.grey;
  }
}

class AnotherTestAlreadyStartedDialog extends StatelessWidget {
  const AnotherTestAlreadyStartedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Constants.attention),
      content: const Text(Constants.anotherTestAlreadyStarted),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
