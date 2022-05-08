import 'dart:html';

import 'package:edudigital/login_page.dart';
import 'package:edudigital/main.dart';
import 'package:edudigital/util_widgets.dart';
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

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(
                  'assets/two_hand.png',
                ))),
        child: Center(
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
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  children(BuildContext context) {
    return <Widget>[
      Expanded(
        child: Element2(),
      ),
      Expanded(
        child: Element1(),
      ),
    ];
  }
}

class Element2 extends StatelessWidget {
  const Element2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => PurchaseDialog());
      },
      style: ElevatedButton.styleFrom(
          shape: StadiumBorder(), primary: Colors.redAccent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Курс наставничества по построению индивидуальной траектории обучения',
          ),
          CustomText(
            '• 72 академических часа\n• Индивидуальное обучение или в группе\n• Личный наставник\n• Много практики\n• Диплом государственного образца',
          ),
        ],
      ),
    );
  }
}

class Element1 extends StatelessWidget {
  const Element1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => PurchaseDialog());
      },
      style: ElevatedButton.styleFrom(
          shape: StadiumBorder(), primary: Colors.blueAccent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Курс наставничества по построению индивидуальной траектории обучения',
          ),
          CustomText(
            '•36 академических часа\n• Индивидуальное обучение или в группе\n• Личный наставник\n• Много практики\n• Сертификат государственного образца',
          ),
        ],
      ),
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
              ApiClient()
                  .createGroup(_emailController.text)
                  .then((value) => Navigator.pop(context, 'OK'));
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
