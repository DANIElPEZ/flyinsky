import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flyinsky/views/mainView.dart';

class splashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => splashState();
}

class splashState extends State<splashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3700), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RiveAnimation.asset(
        "assets/splash_fly.riv",
        alignment: Alignment.center,
        fit: BoxFit.cover,
        stateMachines: ['animation'],
        artboard: 'splash',
      ),
    );
  }
}
