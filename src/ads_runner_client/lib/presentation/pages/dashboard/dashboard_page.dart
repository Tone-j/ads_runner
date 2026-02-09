import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../di/injection_container.dart';
import '../../blocs/dashboard/dashboard_cubit.dart';
import '../../blocs/dashboard/dashboard_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/dashboard/activity_feed.dart';
import '../../widgets/dashboard/metric_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..loadMetrics(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const LoadingIndicator(message: 'Loading dashboard...');
        }
        if (state is DashboardError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().loadMetrics(),
          );
        }
        if (state is DashboardLoaded) {
          final m = state.metrics;
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refreshMetrics(),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const PageHeader(title: 'Dashboard', subtitle: 'Overview of your advertising performance'),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1000 ? 4 : constraints.maxWidth > 600 ? 2 : 1;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      children: [
                        MetricCard(
                          icon: LucideIcons.megaphone,
                          label: 'Active Campaigns',
                          value: m.activeCampaigns.toString(),
                          trend: m.impressionsTrend,
                          iconColor: AppColors.primary,
                        ),
                        MetricCard(
                          icon: LucideIcons.eye,
                          label: 'Total Impressions',
                          value: m.totalImpressions.toCompact,
                          trend: m.impressionsTrend,
                          iconColor: AppColors.secondary,
                        ),
                        MetricCard(
                          icon: LucideIcons.users,
                          label: 'Daily Reach',
                          value: m.dailyReach.toCompact,
                          trend: m.reachTrend,
                          iconColor: AppColors.success,
                        ),
                        MetricCard(
                          icon: LucideIcons.dollarSign,
                          label: 'Monthly Revenue',
                          value: m.monthlyRevenue.toCurrency,
                          trend: m.revenueTrend,
                          iconColor: AppColors.warning,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _ScreensOnlineCard(online: m.onlineScreens, total: m.totalScreens),
                const SizedBox(height: 24),
                ActivityFeed(activities: m.recentActivity),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ScreensOnlineCard extends StatelessWidget {
  final int online;
  final int total;
  const _ScreensOnlineCard({required this.online, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (online / total * 100) : 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.monitor, size: 20, color: AppColors.success),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$online / $total Screens Online', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total > 0 ? online / total : 0,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.success, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
