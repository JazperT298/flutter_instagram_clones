import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_data.dart';
import 'package:flutter_instagram_clone/screens/feed_screen.dart';
import 'package:flutter_instagram_clone/screens/home_screen.dart';
import 'package:flutter_instagram_clone/screens/login_screen.dart';
import 'package:flutter_instagram_clone/screens/onboarding_screen.dart';
import 'package:flutter_instagram_clone/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.
  Widget _getScreenId(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData){
          Provider.of<UserData> (context).currentUserId = snapshot.data.uid;
          return HomeScreen();
        }else {
          return OnboardingScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
            color: Colors.black,
          ),
          // primarySwatch: Colors.blue,
        ),
        home: _getScreenId(),
        routes: {
          OnboardingScreen.id: (context) => OnboardingScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          FeedScreen.id: (context) => FeedScreen(),
        },
      ),
    );
  }
}