import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';
import 'package:task_management_app/blocs/focus_mode/focus_mode_bloc.dart';
import 'package:task_management_app/pages/auth_pages/auth_gate.dart';
import 'package:task_management_app/services/firebase/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../blocs/events/event_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _requestNotificationPermission();
  // Kiểm tra và yêu cầu quyền Exact Alarm cho Android 13+
  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    bool? exactAlarmGranted =
        await androidPlugin.requestExactAlarmsPermission();
    if (exactAlarmGranted == null || !exactAlarmGranted) {
      debugPrint("Exact alarm permission was not granted.");
    }
  }

  // Cấu hình thông báo
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      debugPrint('Notification payload: ${response.payload}');
    },
  );

  runApp(MyApp());
}

/// Yêu cầu quyền thông báo
Future<void> _requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => EventBloc()),
        BlocProvider(create: (context) => FocusModeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TickApp',
        home: AuthGate(),
        // home: FocusPage(),
      ),
    );
  }
}
