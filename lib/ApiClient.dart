import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:edudigital/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UserAgentClient extends http.BaseClient {
  final String userAgent;
  final http.Client _inner;

  UserAgentClient(this.userAgent, this._inner);

  static Future<String> logout() async {
    final response = await http.post(Uri.parse(Constants.BASE_URL + '/logout'));

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  static Future<String> available() async {
    final response = await http
        .get(Uri.parse(Constants.BASE_URL + '/api/v1/tests/available'));

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(response.body);
    }
  }

  static Future<String> auth(String login, String password) async {
    // return Random().nextBool() ? "Студент" : "Учитель";
    // return "Учитель";
    return "Студент";
    final response = await http.post(
      Uri.parse(Constants.BASE_URL + '/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control_Allow_Origin": "*"
      },
      body: jsonEncode(<String, String>{
        // "email": "user6_email@mail.ru",
        // "password": "12345678"
        "email": login,
        "password": password
      }),
    );
    print(response.headers);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      return json['message']['role'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return "error";
    }
  }

  static Future<String> registry(
      String login, String password, String name, String surname) async {
    final response = await http.post(
      Uri.parse(Constants.BASE_URL +
          '/register/8c0fbac9-9fcf-48ce-9e6f-d358839dae1e'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control_Allow_Origin": "*"
      },
      body: jsonEncode(<String, String>{
        // "email": "user6_email@mail.ru",
        // "password": "12345678"
        "email": login,
        "password": password,
        "name": name,
        "surname": surname
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      return json['message']['role'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return "error";
    }
  }

  static Future<String?> uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      var postUri = Uri.parse(Constants.BASE_URL);
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['user'] = 'blah';
      request.files.add(new http.MultipartFile.fromBytes(fileName, fileBytes!));

      request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
      });
    }
  }

  static Future<String> forgetPassword(String login) async {
    final response = await http.post(
      Uri.parse(Constants.BASE_URL + '/forgot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control_Allow_Origin": "*"
      },
      body: jsonEncode(<String, String>{
        // "email": "user6_email@mail.ru"
        "email": login
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      return json['message']['role'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return "error";
    }
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    return _inner.send(request);
  }

  static createGroup(String name, String count) {
    //todo createGroup
  }

  static sendRecomendation(String text) {
    //todo sendRecomendation
  }
}
