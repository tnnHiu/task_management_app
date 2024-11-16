import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:googleapis/calendar/v3.dart';
// import 'package:task_management_app/blocs/auth/auth_bloc.dart';
import 'package:task_management_app/blocs/home_page_navigation/home_page_navigation_bloc.dart';
// import 'package:task_management_app/pages/calendar_page.dart';
import 'package:task_management_app/pages/focus_page.dart';
import 'package:task_management_app/pages/task_pages/task_page.dart';
import 'package:task_management_app/pages/widgets/app_widget.dart';
import 'calendar.dart';
import '../blocs/events/event_bloc.dart';
import '../blocs/task/task_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageNavigationBloc()),
        BlocProvider(create: (context) => TaskBloc()),
        // BlocProvider(create: (context) => CalendarBloc()),
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
          return Center(child: Text("Tasks Page"));
        case 3:
          return FocusPage();
        case 4:
          return Center(child: Text("More"));
        default:
          return Center(child: Text("Home Page"));
      }
    });
  }
}
