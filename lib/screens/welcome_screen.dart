import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    controller.addListener(() {
      setState(() {});
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: animation.value * 60,
                ),
              ),
              TextLiquidFill(
                text: 'Flash Chat',
                waveColor: Colors.blue[200],
                boxBackgroundColor: Colors.red,
                textStyle: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 180.0,
                boxWidth: 250,
              ),
            ]),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In',colour: Colors.lightBlueAccent,onPressed: () {
            Navigator.pushNamed(context, 'login');
          }),
            RoundedButton(title: "Regsiter",colour: Colors.blueAccent,onPressed:  () {
                    Navigator.pushNamed(context, 'registration');
                  },)
          ],
        ),
      ),
    );
  }
}

