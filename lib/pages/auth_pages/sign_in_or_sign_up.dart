import 'package:flutter/material.dart';
import 'package:task_management_app/pages/auth_pages/sign_in_page.dart';
import 'package:task_management_app/pages/auth_pages/sign_up_page.dart';

class SignInOrSignUp extends StatefulWidget {
  const SignInOrSignUp({super.key});

  @override
  State<SignInOrSignUp> createState() => _SignInOrSignUpState();
}

class _SignInOrSignUpState extends State<SignInOrSignUp> {
  bool showSignInPage = true;

  void togglePage() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignInPage(onPressed: togglePage);
    } else {
      return SignUpPage(onPressed: togglePage);
    }
  }
}
