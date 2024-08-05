import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';

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
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print("Verified User");
              } else
                print("You need to verify email");
              return const Text("DONE");
            default:
              return const Text("Loading....");
          }
        },
      ),
    );
  }
}
