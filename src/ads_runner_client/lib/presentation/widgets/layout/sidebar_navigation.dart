import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/navigation/navigation_cubit.dart';
import '../../blocs/navigation/navigation_state.dart';
import '../../router/route_paths.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  static const _navItems = [
    _NavItem(icon: LucideIcons.layoutDashboard, label: 'Dashboard', path: RoutePaths.dashboard),
    _NavItem(icon: LucideIcons.megaphone, label: 'Campaigns', path: RoutePaths.campaigns),
    _NavItem(icon: LucideIcons.barChart3, label: 'Analytics', path: RoutePaths.analytics),
    _NavItem(icon: LucideIcons.monitor, label: 'Screens', path: RoutePaths.screens),
    _NavItem(icon: LucideIcons.map, label: 'Map', path: RoutePaths.screensMap),
    _NavItem(icon: LucideIcons.creditCard, label: 'Subscriptions', path: RoutePaths.subscriptions),
    _NavItem(icon: LucideIcons.settings, label: 'Settings', path: RoutePaths.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final isCollapsed = state.isSidebarCollapsed;
        final width = isCollapsed ? AppConstants.sidebarCollapsedWidth : AppConstants.sidebarExpandedWidth;
        final currentPath = GoRouterState.of(context).matchedLocation;

        return AnimatedContainer(
          duration: AppConstants.animationDuration,
          width: width,
          color: AppColors.sidebarBackground,
          child: Column(
            children: [
              // Logo area
              Container(
                height: AppConstants.topBarHeight,
                padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 16 : 20),
                alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
                child: isCollapsed
                    ? Text('AR', style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary))
                    : Text('AdsRunner', style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 8),
              // Nav items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: _navItems.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isActive = currentPath.startsWith(item.path);
                    return _buildNavItem(context, item, isActive, isCollapsed);
                  }).toList(),
                ),
              ),
              // Collapse toggle
              const Divider(height: 1, color: AppColors.divider),
              InkWell(
                onTap: () => context.read<NavigationCubit>().toggleSidebar(),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  child: Icon(
                    isCollapsed ? LucideIcons.chevronsRight : LucideIcons.chevronsLeft,
                    color: AppColors.textTertiary, size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item, bool isActive, bool isCollapsed) {
    return Tooltip(
      message: isCollapsed ? item.label : '',
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: Material(
          color: isActive ? AppColors.sidebarItemActive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            hoverColor: AppColors.sidebarItemHover,
            onTap: () => context.go(item.path),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: isCollapsed ? 0 : 12),
              child: Row(
                mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Icon(item.icon, size: 20, color: isActive ? AppColors.primary : AppColors.textSecondary),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String path;
  const _NavItem({required this.icon, required this.label, required this.path});
}
