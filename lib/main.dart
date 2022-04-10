import 'package:edudigital/ApiClient.dart';
import 'package:edudigital/teacher_page.dart';
import 'package:edudigital/demo_screen.dart';
import 'package:edudigital/main_screeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'Models.dart';
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
      initialRoute: RoutesName.home,
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
        return MaterialPageRoute(
            builder: (context) => const StudentDetailScreen());
      case RoutesName.trajectory:
        return MaterialPageRoute(
            builder: (context) => const StudentTrajectoryScreen());
      case RoutesName.testScreen:
        return MaterialPageRoute(builder: (context) => const TestScreen());
      case RoutesName.demoScreen:
        return MaterialPageRoute(builder: (context) => const DemoScreen());
      case RoutesName.teacher:
        return MaterialPageRoute(builder: (context) {
          UserAgentClient().getGroups().then((value) {
            if (value.isNotEmpty) {
              context.read<GroupData>().refreshGroupsData(value);
              UserAgentClient()
                  .getGroupDetail(value.first.id)
                  .then((groupDetail) {
                context.read<GroupData>().refreshGroupDetailData(groupDetail);
              });
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
