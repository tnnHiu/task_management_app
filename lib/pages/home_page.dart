import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/blocs/home_page_navigation/home_page_navigation_bloc.dart';
import 'package:task_management_app/pages/calendar_page.dart';
import 'package:task_management_app/pages/widgets/app_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageNavigationBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Icon(Icons.more_vert),
            const SizedBox(width: 12),
          ],
        ),
        backgroundColor: Colors.white,
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
          return Center(child: Text("To do Page"));
        case 1:
          return CalendarPage();
        case 2:
          return Center(child: Text("Tasks Page"));
        case 3:
          return Center(child: Text("Notifications Page"));
        case 4:
          return Center(child: Text("More"));
        default:
          return Center(child: Text("Home Page"));
      }
    });
  }
}
