// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class VerifyEmailView extends StatefulWidget {
//   const VerifyEmailView({super.key});

//   @override
//   State<VerifyEmailView> createState() => _VerifyEmailViewState();
// }

// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Verify"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           const Text("Please verify your email adress"),
//           TextButton(
//               onPressed: () async {
//                 final user = FirebaseAuth.instance.currentUser;
//                 await user?.sendEmailVerification();
//               },
//               child: const Text("Send email verification"))
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Text("Please verify your email address"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().currentUser;

              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              final user = AuthService.firebase().currentUser;

              if (user != null && user.isEmailVerified) {
                // Navigate to home or dashboard screen
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }
            },
            child: const Text("I've verified my email"),
          ),
        ],
      ),
    );
  }
}
