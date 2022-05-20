import 'dart:html';
import 'dart:ui';

import 'package:edudigital/login_page.dart';
import 'package:edudigital/main.dart';
import 'package:edudigital/util_widgets.dart';
import 'package:flutter/material.dart';

import 'ApiClient.dart';

class AnotherDemoScreen extends StatelessWidget {
  const AnotherDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('Курсы повышения педагогов от ЕИ КФУ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Курс наставничества по построению индивидуальной траектории обучения",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "• 72 академических часа",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Индивидуальное обучение или в группе",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                "• Личный наставник",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                "• Много практики",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "• Диплом ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "государственного образца",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Курс повышения цифровой компетентности",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "• 36 академических часа",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Индивидуальное обучение или в группе",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                "• Личный наставник",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                "• Много практики",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "• Сертификат ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "государственного образца",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 20,
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => PurchaseDialog());
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Приобрести",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) // This trailing comma makes auto-formatting nicer for build methods.
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
