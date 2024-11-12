import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';

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
                _inputField(context),
                _forgotPassword(context),
                _signup(context),
                _googleSignInButton(context),
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

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          // controller: _emailController,
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
          // controller: _passwordController,
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
            // context.read<AuthBloc>().add(
            //   LoginRequested(
            //     _emailController.text.trim(),
            //     _passwordController.text.trim(),
            //   ),
            // );
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

  Widget _googleSignInButton(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.purple,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(GoogleSignInEvent());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.add_box_sharp, color: Colors.red),
            Text(
              "Đăng nhập với Google",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
