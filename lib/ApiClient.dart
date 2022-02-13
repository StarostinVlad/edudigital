import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:edudigital/Models.dart';
import 'package:edudigital/constants.dart';
import 'package:edudigital/storage.dart';
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

  Future<List<LevelData>> available() async {
    (_client).withCredentials = true;
    final response = await _client.get(
      Uri.parse(
        Constants.BASE_URL + '/api/v1/tests/available',
      ),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      List<LevelData> levelDataList =
          json.map((levelJson) => LevelData.fromJson(levelJson)).toList();
      print('name ${levelDataList[0].name}');
      return levelDataList;
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

      // String fileName = result.files.first.name;

      // var postUri = Uri.parse(Constants.BASE_URL);
      // var request = new http.MultipartRequest("POST", postUri);
      String base64Image = base64Encode(fileBytes!);
      final response = await _client.post(
        Uri.parse(Constants.BASE_URL + '/api/v1/profile/image'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"image": base64Image}),
      );
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return 'ok';
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        return "error";
      }
      // request.fields['user'] = 'blah';
      // request.files.add(new http.MultipartFile.fromBytes(fileName, fileBytes!));
      //
      // _client.send(request).then((response) {
      //   if (response.statusCode == 200) print("Uploaded!");
      // });
    }
  }

  Future<String> forgetPassword(String login) async {
    (_client).withCredentials = true;
    final response = await _client.post(
      Uri.parse(Constants.BASE_URL + '/forgot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  Future<String?> createGroup(String name, String count) async {
    (_client).withCredentials = true;
    final response = await _client.put(
      Uri.parse(Constants.BASE_URL + '/api/v1/group'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      return json['message'];
    } else if (response.statusCode == 403) {
      throw NotLoginException('Not login!');
    } else {
      throw Exception('Another exception');
    }
  }

  static sendRecomendation(String text) {
    //todo sendRecomendation
  }

  Future<User> getProfile() async {
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
      var json = jsonDecode(response.body);
      return User.fromJson(json);
    } else if (response.statusCode == 403) {
      throw NotLoginException('Not loggin!');
    } else {
      throw Exception('Another exception');
    }
  }

  Future startTest(String testId) async {
    (_client).withCredentials = true;
    final response = await _client.post(
        Uri.parse(Constants.BASE_URL + '/api/v1/test/start/$testId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Repository().setEndTime(DateTime.now().add(Duration(minutes: 30)));

      var json = jsonDecode(response.body);
      return json.toString();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      if (response.statusCode == 409)
        throw TestIsAlredyStartedException("Error");
      throw Exception("error");
    }
  }

  Future<QuestionData> getNextQuestion() async {
    (_client).withCredentials = true;
    final response = await _client.get(
        Uri.parse(Constants.BASE_URL + '/api/v1/question/get_next'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);

      // return json;
      return QuestionData.fromJson(json);
    } else {
      var json = jsonDecode(response.body);
      if (response.statusCode == 404) if (json['message'] != null)
        throw TestIsOverException('Test is over');
      throw Exception("another error");
    }
  }

  Future giveAnswerForQuestion(String id, String getUserAnswerId) async {
    (_client).withCredentials = true;
    final response = await _client.post(
        Uri.parse(Constants.BASE_URL + '/api/v1/question/$id/give_answer'),
        body: jsonEncode(<String, String>{"answer_id": getUserAnswerId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      return json.toString();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception("Error");
      return "error";
    }
  }

  Future<List<Group>> getGroups() async {
    (_client).withCredentials = true;
    final response = await _client.get(
        Uri.parse(Constants.BASE_URL + '/api/v1/groups'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      List<Group> groups =
          json.map((groupJson) => Group.fromJson(groupJson)).toList();
      return groups;
    } else {
      throw Exception("Error");
    }
  }

  Future<GroupDetail> getGroupDetail(String id) async {
    (_client).withCredentials = true;
    final response = await _client.get(
        Uri.parse(Constants.BASE_URL + '/api/v1/group/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    print(response.body);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return GroupDetail.fromJson(json);
    } else {
      throw Exception("Error");
    }
  }
}

class NotLoginException implements Exception {
  String cause;

  NotLoginException(this.cause);
}

class TestIsAlredyStartedException implements Exception {
  String cause;

  TestIsAlredyStartedException(this.cause);
}

class TestIsOverException implements Exception {
  String cause;

  TestIsOverException(this.cause);
}
