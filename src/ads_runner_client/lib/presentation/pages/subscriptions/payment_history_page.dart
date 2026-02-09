import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/payment_history.dart';
import '../../blocs/subscriptions/subscription_cubit.dart';
import '../../blocs/subscriptions/subscription_state.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubscriptionCubit>()..loadSubscription(),
      child: const _PaymentHistoryView(),
    );
  }
}

class _PaymentHistoryView extends StatelessWidget {
  const _PaymentHistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading || state is SubscriptionInitial) {
          return const LoadingIndicator(message: 'Loading payment history...');
        }
        if (state is SubscriptionError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<SubscriptionCubit>().loadSubscription(),
          );
        }
        if (state is SubscriptionLoaded) {
          final payments = state.paymentHistory;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                title: 'Payment History',
                subtitle: '${payments.length} transactions',
                actions: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(RoutePaths.subscriptions),
                    icon: const Icon(LucideIcons.arrowLeft, size: 16),
                    label: const Text('Back to Plans'),
                  ),
                ],
              ),
              if (payments.isEmpty)
                const EmptyState(
                  icon: LucideIcons.receipt,
                  title: 'No payments yet',
                  subtitle: 'Your payment history will appear here',
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.divider)),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text('Date', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 3, child: Text('Description', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 1, child: Text('Amount', style: AppTextStyles.labelSmall)),
                            Expanded(flex: 1, child: Text('Status', style: AppTextStyles.labelSmall)),
                          ],
                        ),
                      ),
                      // Table rows
                      ...payments.map((p) => _PaymentRow(payment: p)),
                    ],
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final PaymentRecord payment;
  const _PaymentRow({required this.payment});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'failed': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(payment.date.toFormatted(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
          ),
          Expanded(
            flex: 3,
            child: Text(payment.description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
          ),
          Expanded(
            flex: 1,
            child: Text(payment.amount.toCurrencyDecimal, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: _statusColor(payment.status), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(payment.status, style: AppTextStyles.bodySmall.copyWith(color: _statusColor(payment.status))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
