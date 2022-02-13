class Constants {
  static const String BASE_URL = "https://10.81.16.77:80";
  static const String greetings_for_student = """Привет, %name%!

  Мы рады приветствовать тебя на платформе, которая покажет насколько ты готов к своей
  профессиональной деятельности!
  Здесь будут встречаться различного вида задания, а
  именно опросы, кейсы, тестирование.
  
  После открытия задания преподавателем у тебя будет
  всего лишь одна попытка пройти его, поэтому
  сосредоточься и сконцентрируйся на задании.
  
  Среднее время прохождения каждого задания – 45 минут.
  
  Желаем удачи!""";

  static const String greetings_for_teach = """Здравствуйте, %name%!

Мы рады приветствовать вас на платформе, которая
поможет вам в оценивании студентов на готовность к

профессиональной деятельности!
Здесь будут встречаться различного вида задания, а
именно опросы, кейсы, тестирование.
После открытия задания у студентов будет всего лишь
одна попытка пройти его. Обеспечьте дисциплину при
прохождении, дабы избежать неверных результатов.
У вас есть возможность создавать группы и
приглашать туда студентов.

Среднее время прохождения каждого задания – 45

минут.""";

  static const students = [
    'Иванов Иван Иванович',
    'Петров Петр Петрович',
    'Соболев Андрей Андреевич'
  ];

  static var isStudent = false;

  static String loadingProfileError = '';

  static String repeat = '';

  static const String anotherTestAlreadyStarted = 'Вы уже выполняете другой тест';

  static const String attention = 'Внимание!';

  static const String watchTrajectory='Моя траектория развития';

  static const String create= 'Создать';
}
