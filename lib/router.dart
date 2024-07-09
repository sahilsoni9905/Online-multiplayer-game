import 'package:flutter/material.dart';
import 'package:mega_app_project/authentication/screens/profile_setup_screen.dart';
import 'package:mega_app_project/authentication/screens/signin_screen.dart';
import 'package:mega_app_project/authentication/screens/signup_screeen.dart';
import 'package:mega_app_project/home/screens/game_screen.dart';
import 'package:mega_app_project/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SignInScreen());
    case ProfileSetupScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const ProfileSetupScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case HomePage.routeName:
      return MaterialPageRoute(builder: (context) => const HomePage());
      case GameScreen.routeName:
       final gameCode = settings.arguments as String;
      return MaterialPageRoute(builder: (context) =>  GameScreen(gameCode: gameCode,));
      
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Something gone wrong'),
          ),
        ),
      );
  }
}
