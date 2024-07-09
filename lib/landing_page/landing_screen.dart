import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mega_app_project/authentication/screens/signin_screen.dart';
import 'package:mega_app_project/home/screens/home_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = '/landingPage';
  LandingScreen({super.key, required this.userFound});
  bool userFound;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late List<String> textLines;
  late int currentLineIndex;

  @override
  void initState() {
    super.initState();
    textLines = ['Welcome To...', 'Gambling App'];
    currentLineIndex = 0;
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentLineIndex < textLines.length - 1) {
        setState(() {
          currentLineIndex++;
        });
      } else {
        timer.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (widget.userFound == false) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(21, 0, 31, 1),
              Color.fromRGBO(66, 1, 51, 1),
              Color.fromRGBO(32, 1, 47, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.75, 0.9],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textLines[0],
              style: GoogleFonts.aclonica(
                textStyle: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  textLines[1],
                  textStyle: GoogleFonts.annapurnaSil(
                    textStyle: const TextStyle(
                        fontSize: 45,
                        color: Color.fromARGB(255, 227, 141, 141)),
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              isRepeatingAnimation: false,
            ),
          ],
        ),
      ),
    );
  }
}
