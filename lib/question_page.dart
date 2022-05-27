import 'dart:async';
import 'dart:html';
import 'dart:ui';
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'constants.dart';
import 'main.dart';
import 'student_page.dart';
import 'util_widgets.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
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

class SoftSkillsScreen extends StatefulWidget {
  const SoftSkillsScreen({Key? key}) : super(key: key);

  @override
  _SoftSkillsScreenState createState() => _SoftSkillsScreenState();
}

class _SoftSkillsScreenState extends State<SoftSkillsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: !MyApp.isDesktop(context)
          ? Drawer(
              child: Menu(),
            )
          : null,
      body: !MyApp.isDesktop(context)
          ? SoftSkills()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, child: Menu()),
                Flexible(child: SoftSkills()),
              ],
            ),
    );
  }
}

class SoftSkills extends StatelessWidget {
  const SoftSkills({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.deepPurple,
          child: CustomText(
            'SoftSkills',
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Text(
            "Самооценка развития ключевых компетенций",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Constants.softSkillBodyText,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: MaterialButton(
                  minWidth: 200,
                  onPressed: (){},
                  color: Colors.blueAccent,
                  child: CustomText(
                    'Описание\nкомпетенций',
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: MaterialButton(
                  minWidth: 200,
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
                  color: Colors.green,
                  child: CustomText(
                    'Начать\nсамооценку',
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OtpTimer extends StatefulWidget {
  DateTime startTime;

  OtpTimer(this.startTime);

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
    // Repository().getEndTime().then((value) {
    //   timerMaxSeconds = value.difference(DateTime.now()).inSeconds;
    //   startTimeout();
    // });
    timerMaxSeconds = widget.startTime.difference(DateTime.now()).inSeconds;
    startTimeout();
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpTimer(context.watch<Data>().getStartTime),
        Expanded(child: QuestionContainer())
      ],
    );
  }
}

class QuestionContainer extends StatelessWidget {
  getNextQuestion(BuildContext context) {
    ApiClient().getNextQuestion().catchError((error, stackTrace) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => TestIsOverDialog());
    }).then((questionData) {
      print("questionData: ${questionData.title}");
      Provider.of<Data>(context, listen: false)
          .refreshQuestionData(questionData);
    });
  }

  const QuestionContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var questionData = context.watch<Data>().getQuestionData;
    print("questionData 2:$questionData");
    if (questionData == null || questionData.status)
      return Center(child: CircularProgressIndicator());
    return ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          // Container(
          //     height: 50,
          //     width: double.infinity,
          //     color: Colors.purple,
          //     child: CustomText(S
          //       _questionData!.title,
          //       fontSize: 32,
          //       color: Colors.white,
          //     )),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
                child: Text(
              questionData.title,
              style: Theme.of(context).textTheme.headline5,
            )),
          ),
          if (questionData.type == "QuestionTypes.SINGLE_SELECT")
            AnswersContainer(questionData.answers)
          else
            MultipleAnswersContainer(questionData.answers),
          MaterialButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              context.read<Data>().refreshQuestionStatus(true);
              print(
                  "questionID: ${questionData.id} answerId:${questionData.answersId}");
              ApiClient()
                  .giveAnswersForQuestion(
                      questionData.id, questionData.answersId)
                  .then((value) {
                getNextQuestion(context);
              });
            },
            child: Text(
              'Далее',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ]);
  }
}

class TestIsOverDialog extends StatelessWidget {
  const TestIsOverDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Constants.attention),
      content: const Text(Constants.testIsOver),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            Navigator.popAndPushNamed(context, RoutesName.student);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class MultipleAnswersContainer extends StatefulWidget {
  final List<AnswerData>? _answers;

  const MultipleAnswersContainer(this._answers, {Key? key}) : super(key: key);

  @override
  State<MultipleAnswersContainer> createState() =>
      _MultipleAnswersContainerState();
}

class _MultipleAnswersContainerState extends State<MultipleAnswersContainer> {
  List<String> answers = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget._answers!.length,
        itemBuilder: (BuildContext context, int index) {
          var answer = widget._answers![index];
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: CheckboxListTile(
                  title: Text(answer.body),
                  value: answer.added,
                  onChanged: (bool? value) {
                    setState(() {
                      answer.added = value!;
                    });
                    if (value != null) {
                      if (value) {
                        answers.add(answer.id);
                        context.read<Data>().addUserAnswerId(answer.id);
                      }
                      if (!value) {
                        answers.remove(answer.id);
                        context.read<Data>().removeUserAnswerId(answer.id);
                      }
                    }
                  },
                )),
          );
        });
  }
}

class AnswersContainer extends StatefulWidget {
  final List<AnswerData>? _answers;

  const AnswersContainer(this._answers, {Key? key}) : super(key: key);

  @override
  State<AnswersContainer> createState() => _AnswersContainerState();
}

class _AnswersContainerState extends State<AnswersContainer> {
  var val;

  @override
  void initState() {
    val = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget._answers!.length,
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
                    .addUserAnswerId(widget._answers![index].id);
                setState(() {
                  val = value;
                });
              },
              activeColor: Colors.green,
            ),
            title: Text(
              widget._answers![index].body,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
