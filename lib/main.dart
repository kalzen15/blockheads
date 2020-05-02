import 'package:flutter/material.dart';
import 'package:shapeup/pages/class_list.dart';
import 'file:///D:/App_DEV/flipr_kanban/lib/screens/forgot_password.dart';
import 'package:shapeup/pages/intro_screen.dart';
import 'package:shapeup/pages/login.dart';
import 'package:shapeup/pages/pdf_viewer.dart';
import 'package:shapeup/pages/registration_screen.dart';
import 'package:shapeup/pages/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        IntroScreen.id:(context)=>IntroScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ForgotPassword.id:(context)=>ForgotPassword(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        PdfViewer.id:(context)=>PdfViewer(),
        ClassList.id:(context)=>ClassList(),
      },
    );
  }
}
