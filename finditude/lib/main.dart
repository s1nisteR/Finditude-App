import 'package:finditude/screens/home_page.dart';
import 'package:finditude/screens/login_page.dart';
import 'package:finditude/services/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:finditude/screens/start_finding_page.dart';
import './themes/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //do lots of heavy stuff here and then when done with it all
  FlutterNativeSplash
      .remove(); //finally remove the splash screen and get to our app

  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final String token = UserPreferences.getToken();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (token == "") {
      return MaterialApp(
        title: 'Finditude',
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const StartFindingPage(3),
      );
    } else {
      return MaterialApp(
        title: 'Finditude',
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const StartFindingPage(3),
      );
    }
  }
}
