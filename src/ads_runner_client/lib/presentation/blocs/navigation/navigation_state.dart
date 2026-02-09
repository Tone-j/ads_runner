import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedIndex;
  final bool isSidebarCollapsed;

  const NavigationState({this.selectedIndex = 0, this.isSidebarCollapsed = false});

  NavigationState copyWith({int? selectedIndex, bool? isSidebarCollapsed}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
    );
  }

  @override
  List<Object> get props => [selectedIndex, isSidebarCollapsed];
}
