part of 'app_widget.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageNavigationBloc, HomePageNavigationState>(
      builder: (context, state) {
        int selectedIndex = state.selectedIndex;
        return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_sharp,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.task,
              ),
              label: "",
            ),

            if (!kIsWeb)
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.center_focus_strong,
                ),
                label: "",
              ),

            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.more_horiz_sharp,
            //   ),
            //   label: "",
            // ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white38,
          currentIndex: selectedIndex,
          // backgroundColor: Colors.white,
          backgroundColor: Color(0xFF242424),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            context.read<HomePageNavigationBloc>().add(
                  HomePageNavigationEvent(
                    pageIndex: index,
                  ),
                );
          },
        );
      },
    );
  }
}
