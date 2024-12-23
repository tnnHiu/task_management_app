import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_management_app/blocs/focus_mode/focus_mode_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    // int minutes = 0;
    // int seconds = 0;
    return BlocListener<FocusModeBloc, FocusModeState>(
      listener: (BuildContext context, FocusModeState state) {
        if (state is FocusModeCompletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Hoàn thành"),
            ),
          );
          _showNotification();

          // context.read<FocusModeBloc>().add(FocusModeCompletedEvent(
          //   pomodoroDuration: (minutes * 60 + seconds),
          //   userId: FirebaseAuth.instance.currentUser!.uid,
          // ));
        }
      },
      child: BlocBuilder<FocusModeBloc, FocusModeState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (BuildContext context, FocusModeState state) {
          return Scaffold(
            backgroundColor: Color(0xFF242424),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tập trung",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CircularPercentIndicator(
                    radius: 180,
                    lineWidth: 8,
                    percent: context.select(
                          (FocusModeBloc bloc) => bloc.state.percent.toDouble(),
                    ),
                    center: Text(
                      context.select(
                            (FocusModeBloc bloc) => bloc.state.timeStr,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    progressColor: Colors.blue,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        highlightElevation: 0,
                        child: const Icon(
                          Icons.timer,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _showTimePicker(context);
                        },
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        highlightElevation: 0,
                        child: state.isRunning
                            ? const Icon(
                          Icons.pause,
                          size: 40,
                          color: Colors.white,
                        )
                            : const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          state.isRunning
                              ? context.read<FocusModeBloc>().add(FocusModePauseEvent())
                              : context.read<FocusModeBloc>().add(FocusModeStartEvent());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'focus_mode_channel',
      'Focus Mode',
      channelDescription: 'Notification for focus mode completion',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('sound_notification'),
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin?.show(
      0,
      'Focus Mode',
      'Hoàn thành',
      platformChannelSpecifics,
      payload: 'Focus Mode Completed',
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    int minutes = 25;
    int seconds = 0;

    // Show time picker dialog
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF353535),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Chọn thời gian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 196, 131, 9),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Phút',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        minutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Giây',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10), // Bo góc viền
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        seconds = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.red), // Đổi màu nút
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 196, 131, 9), // Đổi màu nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bo góc nút
                ),
              ),
              onPressed: () {
                context.read<FocusModeBloc>().add(FocusModeSetTimeEvent(minutes: minutes, seconds: seconds));
                Navigator.of(context).pop();
              },
              child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white)
              ),
            ),
          ],
        );
      },
    );
  }

}
