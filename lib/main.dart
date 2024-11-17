import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/auth/auth_bloc.dart';
import 'package:task_management_app/blocs/focus_mode/focus_mode_bloc.dart';
import 'package:task_management_app/pages/auth_pages/auth_gate.dart';
import 'package:task_management_app/services/firebase/firebase_options.dart';

import '../blocs/events/event_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
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
