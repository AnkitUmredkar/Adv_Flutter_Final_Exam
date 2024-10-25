import 'package:adv_flutter_final_exam/service/google_auth_servide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../home_page.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
                Buttons.google, onPressed: () async {
              await GoogleAuthService.googleAuthService.signInWithGoogle();
              User? user =  GoogleAuthService.googleAuthService.getCurrentUser();
              if(user != null){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage(),));
              }
            }),
            const Gap(20),
            const Text("Sign in With Google")
          ],
        ),
      ),
    );
  }
}
