import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/teacher_page.dart';
import 'package:edudigital/demo_screen.dart';
import 'package:edudigital/main_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'Models.dart';
import 'demo_screen2.dart';
import 'invite_screen.dart';
import 'login_page.dart';
import 'question_page.dart';
import 'student_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // setUrlStrategy(PathUrlStrategy());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Data>(create: (context) => Data()),
      Provider<StudentStatisticData>(
          create: (context) => StudentStatisticData()),
      ChangeNotifierProvider<GroupData>(create: (context) => GroupData()),
    ],
    child: MyApp(),
  ));
}

class RoutesName {
  static const String home = '#/';
  static const String login = '#/login';
  static const String main = '#/main';
  static const String detail = '#/detail';
  static const String trajectory = '#/trajectory';
  static const String testScreen = '#/test_screen';
  static const String demoScreen = '#/demo_screen';
  static const String teacher = '#/teacher';
  static const String student = '#/student';
  static const String inviteStudent = '#/invite';

  static const String softSkills = '#/softSkills';
}

class MyApp extends StatelessWidget {
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 930;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edu-it',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xff1800A2),
        fontFamily: 'arial',
      ),
      // initialRoute: RoutesName.home,
      onGenerateRoute: generateRoute,
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    List<String> pathComponents = settings.name!.split('/');
    print("#/" + pathComponents[1]);
    switch ("#/" + pathComponents[1]) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RoutesName.main:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case RoutesName.detail:
        return MaterialPageRoute(builder: (context) {
          return StudentDetailScreen();
        });
      case RoutesName.trajectory:
        return MaterialPageRoute(builder: (context) {
          ApiClient().getRecomendation().then((comments) {
            if (comments.isNotEmpty) {
              context.read<Data>().refreshStudentCommentsData(comments);
            }
          });
          ApiClient().getStudentStatistic().then((statistic) {
            if (statistic.isNotEmpty) {
              context.read<Data>().refreshStudentStatisticData(statistic);
            }
          });
          return StudentTrajectoryScreen();
        });
      case RoutesName.testScreen:
        return MaterialPageRoute(builder: (context) => const TestScreen());
      case RoutesName.softSkills:
        return MaterialPageRoute(builder: (context) => const SoftSkillsScreen());
      case RoutesName.demoScreen:
        return MaterialPageRoute(
            builder: (context) => const AnotherDemoScreen());
      case RoutesName.teacher:
        return MaterialPageRoute(builder: (context) {
          context.read<GroupData>().refreshLoadingStatus(true);
          var groupId = "";
          if (settings.arguments != null) {
            groupId = settings.arguments as String;

            Future.wait([
              ApiClient().getGroupDetail(groupId),
              ApiClient().getGroupAvailableTests(groupId)
            ]).then((value) {
              value.forEach((element) {
                if (element is GroupDetail)
                  context.read<GroupData>().refreshGroupDetailData(element);
                if (element is List<LevelTeacher>)
                  context.read<GroupData>().refreshLevelsData(element);
              });
            }).then((value) =>
                context.read<GroupData>().refreshLoadingStatus(false));
          } else
            ApiClient().getGroups().then((value) {
              if (value.isNotEmpty) {
                context.read<GroupData>().refreshGroupsData(value);
                groupId = value.first.id;
                Future.wait([
                  ApiClient().getGroupDetail(groupId),
                  ApiClient().getGroupAvailableTests(groupId)
                ]).then((value) {
                  value.forEach((element) {
                    if (element is GroupDetail)
                      context.read<GroupData>().refreshGroupDetailData(element);
                    if (element is List<LevelTeacher>)
                      context.read<GroupData>().refreshLevelsData(element);
                  });
                }).then((value) =>
                    context.read<GroupData>().refreshLoadingStatus(false));
              }
            });
          return TeacherScreen();
        });
      case RoutesName.student:
        return MaterialPageRoute(builder: (context) => StudentScreen());
      case RoutesName.inviteStudent:
        return MaterialPageRoute(
            builder: (context) =>
                InviteStudentScreen(groupId: pathComponents[2]));
      default:
        return MaterialPageRoute(builder: (context) => Page404());
    }
  }
}

class Page404 extends StatelessWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Страница не найдена'),
      ),
      body: Container(
        child: Center(
            child: Text(
          '404: page not found',
          style: Theme.of(context).textTheme.headline2,
        )),
      ),
    );
  }
}
