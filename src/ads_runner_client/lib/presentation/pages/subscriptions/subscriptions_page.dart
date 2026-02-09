import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/subscription.dart';
import '../../blocs/subscriptions/subscription_cubit.dart';
import '../../blocs/subscriptions/subscription_state.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubscriptionCubit>()..loadSubscription(),
      child: const _SubscriptionsView(),
    );
  }
}

class _SubscriptionsView extends StatelessWidget {
  const _SubscriptionsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading || state is SubscriptionInitial) {
          return const LoadingIndicator(message: 'Loading subscription...');
        }
        if (state is SubscriptionError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<SubscriptionCubit>().loadSubscription(),
          );
        }
        if (state is SubscriptionLoaded) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                title: 'Subscriptions',
                subtitle: 'Manage your plan and billing',
                actions: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(RoutePaths.paymentHistory),
                    icon: const Icon(LucideIcons.receipt, size: 16),
                    label: const Text('Payment History'),
                  ),
                ],
              ),
              _CurrentPlanCard(plan: state.currentPlan),
              const SizedBox(height: 24),
              Text('Available Plans', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 500 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: state.availablePlans.length,
                    itemBuilder: (context, index) {
                      final plan = state.availablePlans[index];
                      final isCurrent = plan.tier == state.currentPlan.tier;
                      return _PlanCard(plan: plan, isCurrent: isCurrent);
                    },
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

class _CurrentPlanCard extends StatelessWidget {
  final Subscription plan;
  const _CurrentPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.crown, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Plan', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(plan.tier.displayName, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Text('Status: ${plan.status}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('R${plan.price.toStringAsFixed(0)}', style: AppTextStyles.metricMedium.copyWith(color: AppColors.primary)),
              Text('/month', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Subscription plan;
  final bool isCurrent;
  const _PlanCard({required this.plan, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primarySurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCurrent ? AppColors.primary : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCurrent)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          Text(plan.tier.displayName, style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('R${plan.price.toStringAsFixed(0)}', style: AppTextStyles.metricMedium),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('/mo', style: AppTextStyles.caption),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          ...plan.features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.check, size: 14, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
              ],
            ),
          )),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? OutlinedButton(onPressed: null, child: const Text('Current Plan'))
                : ElevatedButton(onPressed: () {}, child: const Text('Upgrade')),
          ),
        ],
      ),
    );
  }
}
