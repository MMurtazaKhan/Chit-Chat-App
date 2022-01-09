import 'package:flutter/material.dart';
import 'package:chit_chat/screens/welcome_screen.dart';
import 'package:chit_chat/screens/login_screen.dart';
import 'package:chit_chat/screens/registration_screen.dart';
import 'package:chit_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black54),
        ),
      ),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        'chat':(context)=>ChatScreen(),
        'login':(context)=>LoginScreen(),
        'registration':(context)=>RegistrationScreen(),
        WelcomeScreen.id : (context)=>WelcomeScreen()
      },
    );
  }
}