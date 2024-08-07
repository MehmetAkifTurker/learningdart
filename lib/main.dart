import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var appName = "Flutter Demo";
  runApp(
    MaterialApp(
      title: appName,
      // Create a custom theme with Material Design 3 and a color scheme
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set the home screen of the app
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print("email verified");
              } else {
                const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text("Done");

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
