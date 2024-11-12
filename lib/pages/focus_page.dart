import 'package:flutter/material.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                value: 0.15,
                color: Colors.blue,
                backgroundColor: Color.fromARGB(245, 244, 240, 255),
              ),
            ),
            Text('Focus Page'),
          ],
        ),
      ),
    );
  }
}
