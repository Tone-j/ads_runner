import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void selectIndex(int index) => emit(state.copyWith(selectedIndex: index));
  void toggleSidebar() => emit(state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed));
}
