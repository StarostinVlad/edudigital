import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        'Edu-IT',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Center(
            child: InkWell(
              child: Text("Выйти"),
              onTap: () {
                ApiClient().logout();
                Navigator.popAndPushNamed(context, RoutesName.login);
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  ui.Size get preferredSize => Size.fromHeight(50);
}

showProfileImage(var user) {
  try {
    return user!.image.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.memory(
              base64Decode(user.image.toString()),
              errorBuilder: (context, error, stackTrace) {
                return NoAccountImage();
              },
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : throw Exception();
  } catch (exception) {
    return NoAccountImage();
  }
}

class NoAccountImage extends StatelessWidget {
  const NoAccountImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.asset(
        "assets/no_acc_image.jpg",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
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
                ApiClient().uploadImage().then((value) => ApiClient()
                    .getProfile()
                    .then((value) =>
                        context.read<Data>().refreshProfileData(value)));
              },
              child: showProfileImage(user),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  ApiClient().removeImage().then((value) => ApiClient()
                      .getProfile()
                      .then((value) =>
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

class SupportServiceDialog extends StatefulWidget {
  const SupportServiceDialog({Key? key}) : super(key: key);

  @override
  State<SupportServiceDialog> createState() => _SupportServiceDialogState();
}

class _SupportServiceDialogState extends State<SupportServiceDialog> {
  var _msgController = TextEditingController();

  String? _msgError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Обращение в службу поддержки'),
      content: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _msgController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              errorText: _msgError,
              focusColor: Theme.of(context).accentColor,
              border: OutlineInputBorder(),
              hintText: 'Опишите свою проблему',
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
              _msgError = null;
            });
            if (_msgController.text.length < 2) {
              setState(() {
                _msgError = "Сообщение должно быть не короче 2х символов";
              });
            }
            if (_msgError == null) {
              ApiClient()
                  .sendMsg(context.watch<Data>().getProfileData?.email,
                      _msgController.text)
                  .then((value) {
                Navigator.pop(context, 'OK');
              }).catchError((error) {
                _msgError = "Сообщение не отправлено";
              });
            }
          },
          child: const Text(Constants.create),
        ),
      ],
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
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.base != null ? "${groups.base!}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.advanced != null ? "${groups.advanced!}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            groups.professional != null ? "${groups.professional!}%" : "",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: SizedBox(
          height: 50,
          child: Text(
            "${groups.total!}",
            textAlign: ui.TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.bodyText1,
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
            style: Theme.of(context).textTheme.headline6,
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

class StatisticTable extends StatelessWidget {
  final List<StudentResult> statistic;

  const StatisticTable(this.statistic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: statistic.map((e) {
          print("statistic item:$e");
          return StatisticItem(e);
        }).toList(),
      ),
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
      title: const Text('Присоединиться к группе'),
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
              ApiClient()
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
