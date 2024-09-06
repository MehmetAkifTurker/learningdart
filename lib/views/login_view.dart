// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:learningdart/firebase_options.dart';
// import 'package:learningdart/views/register_view.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         backgroundColor: Colors.blue,
//       ),
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return Column(
//                 children: [
//                   TextField(
//                     controller: _email,
//                     enableSuggestions: false,
//                     autocorrect: false,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(hintText: "Enter email"),
//                   ),
//                   TextField(
//                     controller: _password,
//                     obscureText: true,
//                     enableSuggestions: false,
//                     autocorrect: false,
//                     decoration: const InputDecoration(
//                       hintText: "Enter password",
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       final email = _email.text;
//                       final password = _password.text;
//                       try {
//                         final userCredential = await FirebaseAuth.instance
//                             .signInWithEmailAndPassword(
//                           email: email,
//                           password: password,
//                         );
//                         print(userCredential);
//                       } on FirebaseAuthException catch (e) {
//                         if (e.code == "invalid-credential") {
//                           print("user not found");
//                         } else if (e.code == "wrong-password") {
//                           print("wrong password");
//                         }
//                       }
//                     },
//                     child: const Text("Login"),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           '/register/', (route) => false);
//                     },
//                     child: const Text("Register here"),
//                   )
//                 ],
//               );
//             default:
//               return const Text("Loading....");
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "Enter email"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter password",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );

                        final user = AuthService.firebase().currentUser;
                        if (user != null && !user.isEmailVerified) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        }
                      } on UserNotFoundAuthException {
                        await showErrorDialog(
                          context,
                          "User not found",
                        );
                      } on WrongPasswordAuthException {
                        await showErrorDialog(
                          context,
                          "Wrong credentials",
                        );
                      } on GenericAuthException {
                        await showErrorDialog(
                          context,
                          "Something went wrong",
                        );
                      }
                    },
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: const Text("Register here"),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
