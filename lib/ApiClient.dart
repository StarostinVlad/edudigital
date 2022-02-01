import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

class UserAgentClient {
  final BrowserClient _client = (http.Client() as BrowserClient);

  static UserAgentClient? _instance;

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  UserAgentClient._internal() {
    _instance = this;
    (_client).withCredentials = true;
  }

  factory UserAgentClient() {
    print(_instance);
    return _instance ?? UserAgentClient._internal();
  }

  Future<String> logout() async {
    final response =
        await _client.post(Uri.parse(Constants.BASE_URL + '/logout'));

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

  Future available() async {
    (_client).withCredentials = true;
    final response = await _client.get(
      Uri.parse(
        Constants.BASE_URL + '/api/v1/tests/available',
      ),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> auth(String login, String password) async {
    // return Random().nextBool() ? "Студент" : "Учитель";
    // return "Учитель";
    // return "Студент";
    (_client).withCredentials = true;
    final response = await _client.post(
      Uri.parse(Constants.BASE_URL + '/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  Future<String> registry(
      String login, String password, String name, String surname) async {
    (_client).withCredentials = true;
    final response = await _client.post(
      Uri.parse(Constants.BASE_URL +
          '/register/8c0fbac9-9fcf-48ce-9e6f-d358839dae1e'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  Future<String?> uploadImage() async {
    (_client).withCredentials = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      var postUri = Uri.parse(Constants.BASE_URL);
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['user'] = 'blah';
      request.files.add(new http.MultipartFile.fromBytes(fileName, fileBytes!));

      _client.send(request).then((response) {
        if (response.statusCode == 200) print("Uploaded!");
      });
    }
  }

  Future<String> forgetPassword(String login) async {
    (_client).withCredentials = true;
    final response = await _client.post(
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

  static createGroup(String name, String count) {
    //todo createGroup
  }

  static sendRecomendation(String text) {
    //todo sendRecomendation
  }

  Future getProfile() async {
    _client.withCredentials = true;
    final response = await _client.get(
      Uri.parse(Constants.BASE_URL + '/api/v1/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('');
    }
  }
}
