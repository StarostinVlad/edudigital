import 'dart:async';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'main.dart';
import 'util_widgets.dart';

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
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          SupportServiceDialog());
                },
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
    double progress = test.result;
    // double progress = test.total / 10;
    var isCompleted = false;
    if (test.isCompleted != null) isCompleted = test.isCompleted!;
    return MaterialButton(
      onPressed: test.available && !isCompleted
          ? () {
              ApiClient().startTest(test.id).then((value) {
                context.read<Data>().refreshStartTime(value);
                ApiClient().getNextQuestion().then((questionData) {
                  context.read<Data>().refreshQuestionData(questionData);
                  Navigator.popAndPushNamed(context, RoutesName.testScreen);
                });
              }).onError((error, stackTrace) {
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
      child: ListTile(
          leading: getStatus(test.available, isCompleted),
          // Icon(
          //     isCompleted ? Icons.done : Icons.clear,
          //     color: isCompleted ? Colors.green : Colors.red,
          //   ),
          title: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            minHeight: 15,
            valueColor: AlwaysStoppedAnimation<Color>(checkColor(progress)),
            value: progress,
          ),
          subtitle: Text("${test.groupName} : ${test.name}"),
          trailing: Text('${progress * 100}%')),
    );
  }

  Color checkColor(double progress) {
    if (progress <= 0.56)
      return Colors.red;
    else if (progress > 0.56 && progress <= 0.86)
      return Colors.yellow;
    else if (progress > 0.86)
      return Colors.green;
    else
      return Colors.grey;
  }

  getStatus(bool available, bool isCompleted) {
    var status = "--";
    if (!available)
      status = "Недоступен";
    else {
      if (!isCompleted)
        status = "Доступен";
      else
        status = "Пройден";
    }
    return Text(status);
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

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  Future<List<LevelData>> _loadData() => ApiClient().available();

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
      appBar: CustomAppBar(),
      drawer: !MyApp.isDesktop(context) ? Drawer(child: Menu()) : null,
      body: SafeArea(
        child: MyApp.isDesktop(context)
            ? Row(
                children: [
                  Container(width: 200, child: Menu()),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SoftSkillBtn(),
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
            : ListView(
                children: [SoftSkillBtn(), Greetings(), StudentContent()]),
      ),
    );
  }
}

class SoftSkillBtn extends StatelessWidget {
  const SoftSkillBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        ApiClient().startSelfCheck().then((value) {
          context.read<Data>().refreshStartTime(value);
          ApiClient().getNextQuestion().then((questionData) {
            context.read<Data>().refreshQuestionData(questionData);
            Navigator.popAndPushNamed(context, RoutesName.testScreen);
          });
        }).onError((error, stackTrace) {
          if (error is TestIsAlredyStartedException)
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AnotherTestAlreadyStartedDialog());
          else
            Navigator.popAndPushNamed(context, RoutesName.student);
        });
      },
      minWidth: double.infinity,
      color: Colors.deepPurple,
      child: CustomText(
        'SoftSkills',
        fontSize: 32,
        color: Colors.white,
      ),
    );
  }
}

class StudentComments extends StatelessWidget {
  const StudentComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var comments = context.watch<Data>().getComments;
    return AlertDialog(
      title: const Text("Рекомендации от преподавателя"),
      content: comments.isEmpty
          ? Center(child: Text("Рекомендации отсутствуют"))
          : Container(
              width: double.maxFinite,
              child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 5, color: Colors.deepPurple),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            comments[index].comment,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    );
                  })),
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

class StudentStatisticItem extends StatelessWidget {
  const StudentStatisticItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statistic = context.watch<Data>().getStatistic;
    if (statistic.isEmpty)
      return Center(
        child: Text("Статистика отсутствует"),
      );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        shrinkWrap: false,
        children: statistic.map((e) {
          print("statistic item:$e");
          return StatisticItem(e);
        }).toList(),
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  final StudentResult statistic;

  const StatisticItem(this.statistic, {Key? key}) : super(key: key);

  row(BuildContext context, Groups groups) {
    return [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.name,
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.base != null ? "${groups.base! * 100}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.advanced != null ? "${groups.advanced! * 100}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.professional != null ? "${groups.professional! * 100}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "${groups.total! * 100}",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    ];
  }

  List<Widget> header(BuildContext context) {
    return [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "Компетенции",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "Базовый",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "Продвинутый",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "Профессиональный",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "Итого",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var rows = statistic.groups
        .map((element) => TableRow(children: row(context, element)))
        .toList();
    rows.insert(0, TableRow(children: header(context)));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${statistic.name}",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Table(
            border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.black, width: 2),
                outside: BorderSide(color: Colors.black, width: 2)),
            children: rows),
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
      appBar: CustomAppBar(),
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: Menu(),
            )
          : null,
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => StudentComments());
        },
        color: Theme.of(context).accentColor,
        icon: Icon(Icons.chat),
      ),
      body: !MyApp.isDesktop(context)
          ? content()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: Menu()),
                Flexible(child: content()),
              ],
            ),
    );
  }

  content() {
    return Column(
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
        Flexible(child: StudentStatisticItem()),
      ],
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
            Column(
              children:
                  Provider.of<StudentStatisticData>(context, listen: false)
                      .getStatisticData
                      .map((levelData) {
                print(levelData.name);
                return EduProgressLevel(level: levelData, isOpen: true);
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
