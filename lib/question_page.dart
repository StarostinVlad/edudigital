import 'dart:async';
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';


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
