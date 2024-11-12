import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';
import 'package:task_management_app/pages/auth_pages/sign_in_or_sign_up.dart';
import 'package:task_management_app/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return const SignInOrSignUp();
          } else if (state is AuthSuccess) {
            return HomePage();
          } else {
            return CircularProgressIndicator();
            ;
          }
        },
      ),
    );
  }
}
