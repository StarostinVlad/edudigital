import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  User? _data;
  List<LevelData> _levelData = [];

  // UserAndStatistic _userAndStatistic;

  // UserAndStatistic get getUserAndStatistic => _userAndStatistic;

  User? get getProfileData => _data;

  String get getFullname => '${_data!.name} ${_data!.surname}';

  String get getGroup => _data!.surname;

  List<LevelData> get getStatisticData {
    print(_levelData.length);
    return _levelData;
  }

  // void refreshProfileAndStatisticData(
  //     Map<String, dynamic> json, List<dynamic> jsonArray) {
  //   _data = User.fromJson(json);
  //   _levelData = jsonArray.map((levelJson) {
  //     print(levelJson);
  //     return LevelData.fromJson(levelJson);
  //   }).toList();
  //   _userAndStatistic = UserAndStatistic(_data, _levelData);
  //   notifyListeners();
  // }

  void refreshProfileData(Map<String, dynamic> json) {
    _data = User.fromJson(json);
    notifyListeners();
  }

  void refreshStatisticData(List<dynamic> jsonArray) {
    // print(jsonArray);
    _levelData = jsonArray.map((levelJson) {
      print(levelJson);
      return LevelData.fromJson(levelJson);
    }).toList();
    notifyListeners();
  }
}

class User {
  final String email;
  final String id;
  final String image;
  final String name;
  final String surname;

  User(this.email, this.id, this.image, this.name, this.surname);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        id = json['id'],
        image = json['image'] ?? '',
        name = json['name'],
        surname = json['surname'];
}

class LevelData {
  final String? name;
  final List<TestData> tests;

  LevelData(this.name, this.tests);

  LevelData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        tests = (json['tests'] as List).map((testJson) {
          print(json);
          // return TestData(true, "1234", false, 'name', 12, 20);
          return TestData.fromJson(testJson);
        }).toList();
}

class TestData {
  final bool available;
  final String id;
  final bool? isCompleted;
  final String name;
  final int correct, total;

  TestData(this.available, this.id, this.isCompleted, this.name, this.correct,
      this.total);

  TestData.fromJson(Map<String, dynamic> json)
      : available = json['available'],
        id = json['id'],
        isCompleted = json['is_completed'],
        name = json['name'],
        correct = json['result'] == null ? 0 : json['result']['correct'] ?? 0,
        total = json['result'] == null ? 1 : json['result']['total'] ?? 1;
}

class ResultData {
  final int correct, total;

  ResultData.fromJson(Map<String, dynamic> json)
      : correct = json['correct'] ?? Random().nextInt(20),
        // total = json['total'];
        total = 20;

  ResultData(this.correct, this.total);
}

class UserAndStatistic {
  final User? user;
  final List<LevelData>? levelList;

  UserAndStatistic(this.user, this.levelList);
}
