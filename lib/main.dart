import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:progressions/widgets/KnowledgeBasePage.dart';
import 'package:progressions/widgets/login/sign_in_screen.dart';
=======
>>>>>>> ab97150947e1cae8cfeba8e093f4ff8961a24a20

import 'widgets/jam/CreateJamScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color(0xFF414141),
        primaryColor: Color(0xFF525252),
        primaryColorDark: Color(0xFF313131),
        accentColor: Color(0xFFec625f),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // home: CreateJamScreen(),

      home: SignInScreen(),

      // home: HomeScreen(),
    );
  }
}
