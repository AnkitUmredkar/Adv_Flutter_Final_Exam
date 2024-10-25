import 'package:adv_flutter_final_exam/service/google_auth_servide.dart';
import 'package:adv_flutter_final_exam/view/auth/sign_in.dart';
import 'package:adv_flutter_final_exam/view/home_page.dart';
import 'package:flutter/material.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (GoogleAuthService.googleAuthService.getCurrentUser() != null)
        ? const HomePage()
        : const SignIn();
  }
}
