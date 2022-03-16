import 'dart:html';

import 'package:edudigital/login_page.dart';
import 'package:edudigital/main.dart';
import 'package:flutter/material.dart';

import 'ApiClient.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(""),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: MyApp.isDesktop(context)
            ? IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children(context)),
            )
            : ListView(
                shrinkWrap: true,
                children: children(context),
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  children(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Element2(),
      ),
      Expanded(child: Element1()),
    ];
  }
}

class Element2 extends StatelessWidget {
  const Element2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(width: 2, color: Colors.purple)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Курс повышения уровня цифровой компетентности',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  '''• 72 академических часа
• Индивидуальное обучение или в группе
• Личный наставник
• Много практики
• Диплом государственного образца
Бонус: практика работы в системе EDU-IT''',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '''Для того, чтоб получить программу обучения, нажмите на кнопку «Приобрести», укажите свою почту и в самое ближайшее время ожидайте всю подробную информацию''',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          color: Colors.purple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => PurchaseDialog());
          },
          child: Text(
            'Приобрести',
          ),
        ),
      ],
    );
  }
}

class Element1 extends StatelessWidget {
  const Element1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(width: 2, color: Colors.purple)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '''Курс наставничества по построению индивидуальной траектории обучения''',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  '''• 36 академических часа
• Индивидуальное обучение или в группе
• Личный наставник
• Много практики
• Сертификат государственного образца
Бонус: практика работы в системе EDU-IT''',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '''Для того, чтоб получить программу обучения, нажмите на кнопку «Приобрести», укажите свою почту и в самое ближайшее время ожидайте всю подробную информацию''',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          color: Colors.purple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => PurchaseDialog());
          },
          child: Text(
            'Приобрести',
          ),
        ),
      ],
    );
  }
}

class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({Key? key}) : super(key: key);

  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  var _emailController = TextEditingController();
  var _fullnameController = TextEditingController();
  var _organizationController = TextEditingController();

  String? _nameError, _surnameError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text('Заявка на приобретение курса')),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Оставьте заявку и наш менеджер свяжется с вами в кратчайшие сроки.'),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    errorText: _nameError,
                    suffixIcon: Icon(
                      Icons.alternate_email,
                      color: Theme.of(context).accentColor,
                    ),
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Адрес электронной почты',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    errorText: _surnameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'ФИО',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _organizationController,
                  decoration: InputDecoration(
                    errorText: _surnameError,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(),
                    hintText: 'Организация',
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
            if (_emailController.text.length < 2) {
              setState(() {
                _nameError = "Имя должно быть не короче 2х символов";
              });
            }
            if (_fullnameController.text.length < 2) {
              setState(() {
                _surnameError = "Фамилия должна быть не короче 2х символов";
              });
            }
            if (_surnameError == null && _nameError == null) {
              UserAgentClient()
                  .createGroup(_emailController.text, _fullnameController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
