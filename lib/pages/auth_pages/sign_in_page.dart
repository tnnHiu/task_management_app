import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';
import 'package:task_management_app/pages/widgets/app_widget.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key, required this.onPressed});

  final void Function()? onPressed;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context,
                    emailController: emailController,
                    passwordController: passwordController),
                _forgotPassword(context),
                _signup(context),
                AppGoogleSignInButton(onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInEvent());
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Chào Mừng Trở Lại",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Nhập thông tin đăng nhập của bạn"),
      ],
    );
  }

  _inputField(
    BuildContext context, {
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Mật khẩu",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(EmailSignInEvent(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ));
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Quên mật khẩu?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản? "),
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "Đăng ký",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
