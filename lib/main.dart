import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_data.dart';
import 'package:flutter_instagram_clone/screens/feed_screen.dart';
import 'package:flutter_instagram_clone/screens/home_screen.dart';
import 'package:flutter_instagram_clone/screens/login_screen.dart';
import 'package:flutter_instagram_clone/screens/main2.dart';
import 'package:flutter_instagram_clone/screens/onboarding_screen.dart';
import 'package:flutter_instagram_clone/screens/splash_screen.dart';
import 'package:provider/provider.dart';


var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/onboard": (BuildContext context) => OnboardingScreen(),
  "/myapp2": (BuildContext context) => MyApp2(),
  "/login": (BuildContext context) => LoginScreen(),
};

void main() => runApp(new MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes)
);


