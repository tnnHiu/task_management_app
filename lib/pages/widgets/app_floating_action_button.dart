part of 'app_widget.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageNavigationBloc, HomePageNavigationState>(
      builder: (context, state) {
        if (state.selectedIndex >= 3) return Container();
        return FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(),
              ),
            ).then((_) {
            BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent());
          });
          },
          elevation: 0,
          highlightElevation: 0,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        );
      },
    );
  }
}
