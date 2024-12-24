import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/home_page_navigation/home_page_navigation_bloc.dart';
import 'package:task_management_app/pages/chat_ai_pages/chat_ai_page.dart';
import 'package:task_management_app/pages/task_pages/task_page.dart';
import 'package:task_management_app/pages/widgets/app_widget.dart';

import '../blocs/events/event_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../pages/search_pages/search_page.dart';
import 'calendar_pages/calendar.dart';
import 'focus_pages/focus_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageNavigationBloc()),
        BlocProvider(create: (context) => TaskBloc()),
        BlocProvider(create: (context) => EventBloc()),
      ],
      child: Scaffold(
        body: _buildSelectedPage(),
        floatingActionButton: AppFloatingActionButton(),
        bottomNavigationBar: AppBottomNavigationBar(),
      ),
    );
  }

  BlocBuilder<HomePageNavigationBloc, HomePageNavigationState>
      _buildSelectedPage() {
    return BlocBuilder<HomePageNavigationBloc, HomePageNavigationState>(
        builder: (context, state) {
      int selectedIndex = state.selectedIndex;
      switch (selectedIndex) {
        case 0:
          return TaskPage();
        case 1:
          return CalendarPage();
        case 2:
          return SearchPage();
        case 3:
          return ChatAIPage();
        case 4:
          if (kIsWeb) {
            return Container();
          }
          return FocusPage();
        default:
          // return Center(child: Text("Home Page"));
          return TaskPage();
      }
    });
  }
}
