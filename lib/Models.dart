import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Data with ChangeNotifier {
  User? _user;

  QuestionData? _questionData;

  User? get getProfileData => _user;

  QuestionData? get getQuestionData => _questionData;

  String get getFullname => '${_user!.name} ${_user!.surname}';

  String get getGroup => _user!.groupTitle;

  void refreshProfileData(User user) {
    _user = user;
    notifyListeners();
  }

  void refreshQuestionData(QuestionData questionData) {
    _questionData = questionData;
    // notifyListeners();
  }

  String get getUserAnswerId => _questionData!.answerId;

  void refreshUserAnswerId(String id) {
    _questionData!.answerId = id;
    notifyListeners();
  }
}

class StudentStatisticData {
  List<LevelData> _levelData = [];

  List<LevelData> get getStatisticData {
    print(_levelData.length);
    return _levelData;
  }

  void refreshStatisticData(List<LevelData> levelData) {
    _levelData = levelData;
  }
}

class GroupData with ChangeNotifier {
  List<Group> _groups = [];

  GroupDetail? _groupDetail;

  GroupDetail? get groupDetail => _groupDetail;

  List<Group> get groups => _groups;

  void refreshGroupsData(List<Group> groups) {
    _groups = groups;
    notifyListeners();
  }

  void refreshGroupDetailData(GroupDetail groupDetail) {
    _groupDetail = groupDetail;
    notifyListeners();
  }

  void removeMember(int index) {
    _groupDetail?.members.removeAt(index);
    notifyListeners();
  }

  void changeMemberStatus(int index) {
    _groupDetail?.members[index].status = Status.loading;
    notifyListeners();
  }

  void removeGroup(int index) {
    _groups.removeAt(index);
    notifyListeners();
  }

  void changeGroupStatus(int index) {
    _groups[index].status = Status.loading;
    notifyListeners();
  }
}

class GroupDetail {
  final String id, link, name;
  final List<User> members;

  GroupDetail(this.id, this.link, this.name, this.members);

  GroupDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        link = json['link'] ?? '',
        name = json['name'],
        members = (json['members'] as List).map((memberJson) {
          return User.fromJson(memberJson);
        }).toList();
}

enum Status { loading, done }

class Group {
  final String id, link, name;
  Status status = Status.done;

  Group(this.id, this.link, this.name);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        link = json['link'] ?? '',
        name = json['name'];
}

class User {
  final String email;
  final String id;
  final String image;
  final String name;
  final String surname, groupId, groupTitle, role;
  Status status = Status.done;

  User(this.email, this.id, this.image, this.name, this.surname, this.groupId,
      this.groupTitle, this.role);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        id = json['id'],
        image = json['image'] ?? '',
        name = json['name'],
        surname = json['surname'],
        groupId = json['group'] != null ? json['group']['id'] : '',
        groupTitle = json['group'] != null ? json['group']['name'] : '',
        role = json['role']['name'];
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

class QuestionData {
  final String body, id, title;
  final List<AnswerData>? answers;
  String answerId = '';

  QuestionData(this.body, this.id, this.title, this.answers);

  QuestionData.fromJson(Map<String, dynamic> json)
      : body = json['body'],
        id = json['id'],
        title = json['title'],
        answers = (json['answers'] as List).map((answerJson) {
          print('json: $json');
          return AnswerData.fromJson(answerJson);
        }).toList();
}

class AnswerData {
  final String body, id, image;

  AnswerData(this.body, this.id, this.image);

  AnswerData.fromJson(Map<String, dynamic> json)
      : body = json['body'],
        id = json['id'],
        image = json['image_path'] ?? '';
}
