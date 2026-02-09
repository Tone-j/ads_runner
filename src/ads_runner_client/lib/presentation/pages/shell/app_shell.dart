import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/layout/sidebar_navigation.dart';
import '../../widgets/layout/top_app_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const SidebarNavigation(),
          Expanded(
            child: Column(
              children: [
                const TopAppBarWidget(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
