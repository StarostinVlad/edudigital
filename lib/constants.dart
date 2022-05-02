import 'dart:convert';

import 'package:flutter/material.dart';

class Constants {

  // static const String BASE_URL = "https://10.81.16.61:80";
  static const String BASE_URL = "https://edu-it.online";
  static const String greetings_for_student =
      "Привет, %name%!\nМы рады приветствовать тебя на платформе, которая\nпокажет насколько ты готов к своей\nпрофессиональной деятельности!\n\nЗдесь будут встречаться различного вида задания, а именно опросы, кейсы, тестирование.\n\n После открытия задания преподавателем у тебя будет всего лишь одна попытка пройти его, поэтому сосредоточься и сконцентрируйся на задании.\n\nСреднее время прохождения каждого задания – 45 минут.\n\nЖелаем удачи!";

  static const String greetings_for_teach =
      "Здравствуйте, %name%!\nМы рады приветствовать вас на платформе, которая поможет вам в оценивании студентов на готовность к профессиональной деятельности!\n\nЗдесь будут встречаться различного вида задания, а именно опросы, кейсы, тестирование.\n\nПосле открытия задания у студентов будет всего лишь одна попытка пройти его. Обеспечьте дисциплину при прохождении, дабы избежать неверных результатов. У вас есть возможность создавать группы и приглашать туда студентов.\n\nСреднее время прохождения каждого задания – 45 минут.";

  static const students = [
    'Иванов Иван Иванович',
    'Петров Петр Петрович',
    'Соболев Андрей Андреевич'
  ];

  static var isStudent = false;

  static String loadingProfileError = '';

  static String repeat = '';

  static const String anotherTestAlreadyStarted =
      'Вы уже выполняете другой тест';

  static const String attention = 'Внимание!';

  static const String watchTrajectory = 'Моя траектория развития';

  static const String create = 'Создать';

  static const String testIsOver = 'Тест завершен!';
}
