import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/theme/theme_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadProfile(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          // Profile loaded/updated successfully
        }
        if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading || state is SettingsInitial) {
          return const LoadingIndicator(message: 'Loading settings...');
        }
        if (state is SettingsError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<SettingsCubit>().loadProfile(),
          );
        }
        if (state is SettingsLoaded) {
          return _SettingsContent(state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SettingsContent extends StatefulWidget {
  final SettingsLoaded state;
  const _SettingsContent({required this.state});

  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.state.profile.firstName);
    _lastNameController = TextEditingController(text: widget.state.profile.lastName);
  }

  @override
  void didUpdateWidget(covariant _SettingsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.profile != widget.state.profile) {
      _firstNameController.text = widget.state.profile.firstName;
      _lastNameController.text = widget.state.profile.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.state.profile;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(title: 'Settings', subtitle: 'Manage your profile and preferences'),
        // Profile section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primarySurface,
                    child: Text(profile.initials, style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.fullName, style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Text(profile.email, style: AppTextStyles.bodySmall),
                        if (profile.companyName != null) ...[
                          const SizedBox(height: 2),
                          Text(profile.companyName!, style: AppTextStyles.caption),
                        ],
                      ],
                    ),
                  ),
                  Text(profile.role.name.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 24),
              Text('Edit Profile', style: AppTextStyles.h4),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: profile.email,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<SettingsCubit>().updateProfile(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated'), backgroundColor: AppColors.success),
                  );
                },
                icon: const Icon(LucideIcons.save, size: 16),
                label: const Text('Save Changes'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Appearance section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appearance', style: AppTextStyles.h4),
              const SizedBox(height: 16),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return SwitchListTile(
                    title: Text('Dark Mode', style: AppTextStyles.bodyMedium),
                    subtitle: Text('Toggle between light and dark theme', style: AppTextStyles.caption),
                    value: themeState.themeMode == ThemeMode.dark,
                    activeTrackColor: AppColors.primary,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Account actions
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account', style: AppTextStyles.h4),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
                icon: const Icon(LucideIcons.logOut, size: 16),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
