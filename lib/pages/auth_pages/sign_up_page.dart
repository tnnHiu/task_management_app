import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // void _registerUser() async {
  //   // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(content: Text('Mật khẩu không khớp')),
  //     );
  //     return;
  //   }
  //
  //   // Kiểm tra độ dài mật khẩu (ít nhất 6 ký tự)
  //   if (_passwordController.text.length < 6) {
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(content: Text('Mật khẩu cần ít nhất 6 ký tự')),
  //     );
  //     return;
  //   }
  //
  //   try {
  //     // Tạo tài khoản người dùng
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //
  //     // Cập nhật tên hiển thị của người dùng
  //     await userCredential.user?.updateDisplayName(_usernameController.text);
  //
  //     // Hiển thị hộp thoại thông báo đăng ký thành công
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Đăng ký thành công'),
  //         content: Text('Tài khoản của bạn đã được tạo thành công.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Đóng hộp thoại
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => LoginPage()),
  //               );
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     // Xử lý lỗi từ Firebase
  //     String errorMessage;
  //     if (e.code == 'weak-password') {
  //       errorMessage = 'Mật khẩu quá yếu.';
  //     } else if (e.code == 'email-already-in-use') {
  //       errorMessage = 'Tài khoản đã tồn tại với email này.';
  //     } else if (e.code == 'invalid-email') {
  //       errorMessage = 'Địa chỉ email không hợp lệ.';
  //     } else {
  //       errorMessage = 'Đã xảy ra lỗi: ${e.message}';
  //     }
  //
  //     // Hiển thị thông báo lỗi
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(content: Text(errorMessage)),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("da co tai khoan? "),
            TextButton(
              onPressed: widget.onPressed,
              child: const Text(
                "Đăng nhap",
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
