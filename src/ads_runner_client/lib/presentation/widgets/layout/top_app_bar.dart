import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class TopAppBarWidget extends StatelessWidget {
  const TopAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          const Spacer(),
          // Notification bell
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 20, color: AppColors.textSecondary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          // User avatar and menu
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final name = state is AuthAuthenticated ? state.user.fullName : 'User';
              final initials = state is AuthAuthenticated ? state.user.initials : 'U';
              return PopupMenuButton<String>(
                offset: const Offset(0, 48),
                color: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.border)),
                onSelected: (value) {
                  if (value == 'logout') context.read<AuthBloc>().add(const LogoutRequested());
                },
                itemBuilder: (context) => [
                  PopupMenuItem(enabled: false, child: Text(name, style: AppTextStyles.labelLarge)),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'logout', child: Row(children: [
                    Icon(LucideIcons.logOut, size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text('Sign out'),
                  ])),
                ],
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16, backgroundColor: AppColors.primarySurface,
                      child: Text(initials, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(name, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(width: 4),
                    const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textTertiary),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
