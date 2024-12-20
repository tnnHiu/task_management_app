part of 'app_widget.dart';

class AppGoogleSignInButton extends StatelessWidget {
  final void Function()? onPressed;

  const AppGoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
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
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Icon(Icons.add_box_sharp, color: Colors.red),
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
