import 'package:cookbook/pages/home.dart';
import 'package:cookbook/util/colors.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firebase_options.dart';
import 'pages/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showIntro = true;
  bool _remember = false;
  String username = "";

  @override
  void initState(){
    super.initState();
    _checkRememberStatus();
  }

  Future<void> _checkRememberStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _remember = prefs.getBool('remember') ?? false;
  }

  void _completeIntro() {
    setState(() {
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: MyColors.myBlack,
        highlightColor: MyColors.myBlack
      ),
      home: _showIntro
        ? IntroPage(onIntroComplete: _completeIntro)
        : (_remember ? const Homepage() : const LoginPage()),
    );
  }
}
