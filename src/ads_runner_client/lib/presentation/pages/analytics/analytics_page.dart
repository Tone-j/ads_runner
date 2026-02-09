import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../blocs/analytics/analytics_cubit.dart';
import '../../blocs/analytics/analytics_state.dart';
import '../../widgets/analytics/performance_line_chart.dart';
import '../../widgets/analytics/reach_donut_chart.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnalyticsCubit>()..loadAnalytics(null),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading || state is AnalyticsInitial) {
          return const LoadingIndicator(message: 'Loading analytics...');
        }
        if (state is AnalyticsError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<AnalyticsCubit>().loadAnalytics(null),
          );
        }
        if (state is AnalyticsLoaded) {
          final a = state.analytics;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const PageHeader(title: 'Analytics', subtitle: 'Campaign performance insights'),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.0,
                    children: [
                      _StatCard(icon: LucideIcons.eye, label: 'Total Impressions', value: a.totalImpressions.toCompact, color: AppColors.primary),
                      _StatCard(icon: LucideIcons.users, label: 'Total Reach', value: a.totalReach.toCompact, color: AppColors.secondary),
                      _StatCard(icon: LucideIcons.mousePointerClick, label: 'CTR', value: a.ctr.toPercentage, color: AppColors.success),
                      _StatCard(icon: LucideIcons.trendingUp, label: 'Avg Daily Impressions', value: a.avgDailyImpressions.toCompact, color: AppColors.warning),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              PerformanceLineChart(dataPoints: a.dataPoints),
              const SizedBox(height: 24),
              ReachDonutChart(data: state.geographicData),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.metricMedium),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
