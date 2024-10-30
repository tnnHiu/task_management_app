import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_page_navigation_event.dart';
part 'home_page_navigation_state.dart';

class HomePageNavigationBloc
    extends Bloc<HomePageNavigationEvent, HomePageNavigationState> {
  HomePageNavigationBloc() : super(HomePageNavigationState(selectedIndex: 0)) {
    on<HomePageNavigationEvent>((event, emit) {
      emit(HomePageNavigationState(selectedIndex: event.pageIndex));
    });
  }
}
