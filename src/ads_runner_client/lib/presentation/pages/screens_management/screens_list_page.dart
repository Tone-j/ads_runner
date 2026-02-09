import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/enums/screen_status.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/screen_device.dart';
import '../../blocs/screens_management/screens_cubit.dart';
import '../../blocs/screens_management/screens_state.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/common/status_badge.dart';

class ScreensListPage extends StatelessWidget {
  const ScreensListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScreensCubit>()..loadScreens(),
      child: const _ScreensListView(),
    );
  }
}

class _ScreensListView extends StatelessWidget {
  const _ScreensListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreensCubit, ScreensState>(
      builder: (context, state) {
        if (state is ScreensLoading || state is ScreensInitial) {
          return const LoadingIndicator(message: 'Loading screens...');
        }
        if (state is ScreensError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<ScreensCubit>().loadScreens(),
          );
        }
        if (state is ScreensLoaded) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                title: 'Screens',
                subtitle: '${state.screens.length} devices',
              ),
              Row(
                children: [
                  SearchField(
                    hint: 'Search screens...',
                    onChanged: (q) => context.read<ScreensCubit>().searchScreens(q),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            isSelected: state.activeFilter == null,
                            onTap: () => context.read<ScreensCubit>().filterByStatus(null),
                          ),
                          ...ScreenStatus.values.map((s) => _FilterChip(
                            label: s.label,
                            isSelected: state.activeFilter == s,
                            onTap: () => context.read<ScreensCubit>().filterByStatus(s),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.screens.isEmpty)
                const EmptyState(
                  icon: LucideIcons.monitor,
                  title: 'No screens found',
                  subtitle: 'Try adjusting your search or filters',
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 500 ? 2 : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: state.screens.length,
                      itemBuilder: (context, index) => _ScreenCard(screen: state.screens[index]),
                    );
                  },
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ScreenCard extends StatelessWidget {
  final ScreenDevice screen;
  const _ScreenCard({required this.screen});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/screens/${screen.id}'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: screen.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(LucideIcons.monitor, size: 16, color: screen.status.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(screen.name, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis)),
                  StatusBadge(label: screen.status.label, color: screen.status.color),
                ],
              ),
              const Spacer(),
              Text(screen.vehiclePlate, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Last seen: ${screen.lastSeen.timeAgo}', style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primarySurface,
        checkmarkColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
