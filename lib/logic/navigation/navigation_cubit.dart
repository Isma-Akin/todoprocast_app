import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todoprocast_app/logic/navigation/constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavBarItem.home, 0));

  // void updateNavBarItem(NavBarItem navBarItem) {
  //   if (navBarItem == NavBarItem.home) {
  //     emit(NavigationState(NavBarItem.home, 0));
  //   } else if (navBarItem == NavBarItem.settings) {
  //     emit(NavigationState(NavBarItem.profile, 1));
  //   }
  // }

  void updateNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.home:
        emit(NavigationState(NavBarItem.home, 0));
        break;
      case NavBarItem.settings:
        emit(NavigationState(NavBarItem.settings, 1));
        break;
      case NavBarItem.profile:
        emit(NavigationState(NavBarItem.profile, 2));
        break;
    }
}
}