import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';

import '../widgets/app_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputFields(context),
                    const SizedBox(height: 20),
                    _buildSignInRow(context),
                    const SizedBox(height: 20),
                    AppGoogleSignInButton(onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInEvent());
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Đăng ký",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _userNameController,
          hintText: "Tên người dùng",
          icon: Icons.person,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _emailController,
          hintText: "Email",
          icon: Icons.email,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _passwordController,
          hintText: "Mật khẩu",
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: "Xác nhận mật khẩu",
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _handleEmailSignUp(context),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Đăng ký",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.purple.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Đã có tài khoản? "),
        TextButton(
          onPressed: widget.onPressed,
          child: const Text(
            "Đăng nhập",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }

  void _handleEmailSignUp(BuildContext context) {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String username = _userNameController.text.trim();

    // Gửi sự kiện đăng ký
    BlocProvider.of<AuthBloc>(context).add(
      EmailSignUpEvent(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        username: username,
      ),
    );
  }
}
