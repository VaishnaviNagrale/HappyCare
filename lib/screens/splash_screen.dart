// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:happycare/auth/signin_page.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'Splash_screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    });
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Colors.blue,
      Colors.green,
      Colors.pink,
      Colors.yellow,
      Colors.orange
    ],
    stops: [0.0, 0.25, 0.50, 0.75, 1.0],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/swastyaseva-logo.jpg'),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'स्वास्थ्यसेवा',
                  style: TextStyle(
                    foreground: Paint()..shader = linearGradient,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const Text(
                'Empowering Wellness, Connecting Communities',
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
