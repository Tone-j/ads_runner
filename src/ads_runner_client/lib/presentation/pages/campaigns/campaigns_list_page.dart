import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/enums/campaign_status.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/campaign_summary.dart';
import '../../blocs/campaigns/campaign_list/campaign_list_cubit.dart';
import '../../blocs/campaigns/campaign_list/campaign_list_state.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/common/status_badge.dart';

class CampaignsListPage extends StatelessWidget {
  const CampaignsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CampaignListCubit>()..loadCampaigns(),
      child: const _CampaignsListView(),
    );
  }
}

class _CampaignsListView extends StatelessWidget {
  const _CampaignsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignListCubit, CampaignListState>(
      builder: (context, state) {
        if (state is CampaignListLoading || state is CampaignListInitial) {
          return const LoadingIndicator(message: 'Loading campaigns...');
        }
        if (state is CampaignListError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<CampaignListCubit>().loadCampaigns(),
          );
        }
        if (state is CampaignListLoaded) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                title: 'Campaigns',
                subtitle: '${state.campaigns.length} campaigns',
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(RoutePaths.campaignNew),
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('New Campaign'),
                  ),
                ],
              ),
              Row(
                children: [
                  SearchField(
                    hint: 'Search campaigns...',
                    onChanged: (q) => context.read<CampaignListCubit>().searchCampaigns(q),
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
                            onTap: () => context.read<CampaignListCubit>().filterByStatus(null),
                          ),
                          ...CampaignStatus.values.map((s) => _FilterChip(
                            label: s.label,
                            isSelected: state.activeFilter == s,
                            onTap: () => context.read<CampaignListCubit>().filterByStatus(s),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.campaigns.isEmpty)
                EmptyState(
                  icon: LucideIcons.megaphone,
                  title: 'No campaigns found',
                  subtitle: state.searchQuery.isNotEmpty
                      ? 'Try adjusting your search or filters'
                      : 'Create your first campaign to get started',
                  actionLabel: state.searchQuery.isEmpty ? 'New Campaign' : null,
                  onAction: state.searchQuery.isEmpty ? () => context.go(RoutePaths.campaignNew) : null,
                )
              else
                ...state.campaigns.map((c) => _CampaignCard(campaign: c)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignSummary campaign;
  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go('/campaigns/${campaign.id}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: campaign.thumbnailUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            campaign.thumbnailUrl!,
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                            errorBuilder: (_, __, ___) =>
                                const Icon(LucideIcons.megaphone, color: AppColors.primary, size: 20),
                          ),
                        )
                      : const Icon(LucideIcons.megaphone, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(campaign.name, style: AppTextStyles.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        '${campaign.startDate.toFormatted()} - ${campaign.endDate.toFormatted()}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusBadge(label: campaign.status.label, color: campaign.status.color),
                    const SizedBox(height: 8),
                    Text('${campaign.impressions.toCompact} impressions', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
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
