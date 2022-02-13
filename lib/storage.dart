import 'dart:html';

class Repository {
  final Storage _localStorage = window.localStorage;

  Future setEndTime(DateTime endTime) async {
    _localStorage['end_time'] = endTime.toIso8601String();
  }

  Future<DateTime> getEndTime() async => DateTime.parse(_localStorage['end_time']!);

  Future invalidate() async {
    _localStorage.remove('selected_id');
  }
}
