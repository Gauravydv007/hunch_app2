import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/chat/Chatpage.dart';
import 'package:hunch_app/screens/Home_screen.dart';
import 'package:hunch_app/screens/LoginPage.dart';
import 'package:hunch_app/model/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hunch App',
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            // Show loading indicator or splash screen while checking authentication state
            if (snapshot.hasData) {
              // User is authenticated, navigate to Homepage
              return HomeScreen();
            } else {
              // User is not authenticated, navigate to Login page
              return Login();
            }
          }
        },
      ),
    );
  }
}
