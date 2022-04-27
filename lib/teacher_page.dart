import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/login_page.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'package:flutter/services.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'main.dart';
import 'util_widgets.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({Key? key}) : super(key: key);

  @override
  _StudentDetailScreen createState() => _StudentDetailScreen();
}

class _StudentDetailScreen extends State<StudentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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
                    UserAgentClient()
                        .getGroupAvailableTests(value.first.id)
                        .then((levels) {
                      context.read<GroupData>().refreshLevelsData(levels);
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
    print(members);
    if (members == null) return CircularProgressIndicator();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.detail);
                },
                child: ListTile(
                  leading: showProfileImage(members[index]),
                  title: CustomText(
                    '${members[index].name} ${members[index].surname}',
                    color: Colors.black,
                    padding: 15.0,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            members[index].status == Status.done
                ? InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.read<GroupData>().changeMemberStatus(index);
                      UserAgentClient()
                          .removeStudentFromGroup(members[index].id)
                          .then((value) {
                        context.read<GroupData>().removeMember(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(Icons.cancel, size: 15),
                    ),
                  )
                : SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator())
          ],
        );
      },
    );
  }
}

class GroupsList extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.watch<GroupData>().groupDetail!.name,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: levelList(context.watch<GroupData>().levels),
          )
        ]),
      );
}

levelList(List<LevelTeacher> levels) {
  return levels.map((level) => Level(level)).toList();
}

class Level extends StatelessWidget {
  final LevelTeacher level;

  const Level(this.level, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      shrinkWrap: true,
      children: [
        CustomText(
          level.levelName,
          color: Colors.blue,
          fontSize: 16.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ResponsiveGridList(
              horizontalGridSpacing: 5,
              horizontalGridMargin: 5,
              verticalGridMargin: 5,
              minItemWidth: 200,
              minItemsPerRow: 1,
              maxItemsPerRow: 5,
              shrinkWrap: true,
              children: level.tests.map((test) => AccessLevel(test)).toList()),
        )
      ],
    ));
  }
}

class AccessLevel extends StatefulWidget {
  final TestTeacherData test;

  const AccessLevel(this.test, {Key? key}) : super(key: key);

  @override
  _AccessLevelState createState() => _AccessLevelState();
}

class _AccessLevelState extends State<AccessLevel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: MaterialButton(
        color: widget.test.isAvailable
            ? Colors.green
            : Theme.of(context).accentColor,
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AccessLevelDialog(widget.test.id));
        },
        child: Text(
          widget.test.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AccessLevelDialog extends StatefulWidget {
  final String testId;

  const AccessLevelDialog(this.testId, {Key? key}) : super(key: key);

  @override
  _AccessLevelDialogState createState() => _AccessLevelDialogState();
}

class _AccessLevelDialogState extends State<AccessLevelDialog> {
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
            UserAgentClient()
                .makeTestAvailable(groupDetail?.id, widget.testId)
                .then((value) {
              UserAgentClient()
                  .getGroupAvailableTests(groupDetail!.id)
                  .then((value) => Navigator.pop(context, 'OK'));
            });
          },
          child: const Text('Предоставить'),
        ),
      ],
    );
  }
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
            ListView(shrinkWrap: true, children: [
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
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    UserAgentClient()
                        .getGroupDetail(groups[index].id)
                        .then((groupDetail) {
                      context
                          .read<GroupData>()
                          .refreshGroupDetailData(groupDetail);
                    });
                    UserAgentClient()
                        .getGroupAvailableTests(groups[index].id)
                        .then((levels) {
                      context.read<GroupData>().refreshLevelsData(levels);
                    });
                  },
                  child: ListTile(
                    title: CustomText(
                      groups[index].name,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              groups[index].status == Status.done
                  ? InkWell(
                      onTap: () {
                        context.read<GroupData>().changeGroupStatus(index);
                        UserAgentClient()
                            .removeGroup(groups[index].id)
                            .then((value) {
                          context.read<GroupData>().removeGroup(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.cancel,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator())
            ],
          ),
        );
      },
    );
  }
}
