import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/media_asset.dart';
import '../../blocs/campaigns/campaign_detail/campaign_detail_cubit.dart';
import '../../blocs/campaigns/campaign_detail/campaign_detail_state.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignDetailCubit, CampaignDetailState>(
      builder: (context, state) {
        if (state is CampaignDetailLoading || state is CampaignDetailInitial) {
          return const LoadingIndicator(message: 'Loading campaign...');
        }
        if (state is CampaignDetailError) {
          return ErrorDisplay(message: state.message);
        }
        if (state is CampaignDetailLoaded) {
          final c = state.campaign;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                title: c.name,
                subtitle: c.description,
                actions: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(RoutePaths.campaigns),
                    icon: const Icon(LucideIcons.arrowLeft, size: 16),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/campaigns/${c.id}/edit'),
                    icon: const Icon(LucideIcons.pencil, size: 16),
                    label: const Text('Edit'),
                  ),
                ],
              ),
              Row(
                children: [
                  StatusBadge(label: c.status.label, color: c.status.color),
                  const SizedBox(width: 12),
                  Text('${c.startDate.toFormatted()} - ${c.endDate.toFormatted()}', style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(height: 24),
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
                      _InfoCard(icon: LucideIcons.eye, label: 'Impressions', value: c.impressions.toCompact, color: AppColors.primary),
                      _InfoCard(icon: LucideIcons.users, label: 'Reach', value: c.reach.toCompact, color: AppColors.secondary),
                      _InfoCard(icon: LucideIcons.dollarSign, label: 'Budget', value: c.budget.toCurrency, color: AppColors.success),
                      _InfoCard(icon: LucideIcons.mapPin, label: 'Regions', value: c.targetRegions.length.toString(), color: AppColors.warning),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Billboard Preview
              _BillboardPreview(mediaAssets: c.mediaAssets),
              const SizedBox(height: 16),
              // Media Assets List
              _MediaAssetsList(mediaAssets: c.mediaAssets),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Target Regions', style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: c.targetRegions.map((r) => Chip(
                        label: Text(r.displayName, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
                        backgroundColor: AppColors.surfaceVariant,
                        side: BorderSide.none,
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Timeline', style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    _TimelineRow(label: 'Created', value: c.createdAt.toFullDateTime()),
                    _TimelineRow(label: 'Last Updated', value: c.updatedAt.toFullDateTime()),
                    _TimelineRow(label: 'Start Date', value: c.startDate.toFormatted()),
                    _TimelineRow(label: 'End Date', value: c.endDate.toFormatted()),
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

// ── Billboard Preview ──

class _BillboardPreview extends StatelessWidget {
  final List<MediaAsset> mediaAssets;
  const _BillboardPreview({required this.mediaAssets});

  @override
  Widget build(BuildContext context) {
    final bannerAsset = mediaAssets
        .where((a) => a.fileType.startsWith('image/'))
        .cast<MediaAsset?>()
        .firstOrNull;
    final videoAsset = mediaAssets
        .where((a) => a.fileType.startsWith('video/'))
        .cast<MediaAsset?>()
        .firstOrNull;

    return Container(
      padding: const EdgeInsets.all(20),
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
              const Icon(LucideIcons.monitor, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Billboard Preview', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'This is how your ad appears on taxi billboard screens',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),

          // Billboard frame
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: bannerAsset != null
                      ? Image.network(
                          bannerAsset.fileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderScreen(),
                        )
                      : _placeholderScreen(),
                ),
              ),
            ),
          ),

          // Video asset
          if (videoAsset != null) ...[
            const SizedBox(height: 20),
            Text('Video Asset', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          videoAsset.thumbnailUrl ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(LucideIcons.video, color: AppColors.textTertiary, size: 40),
                          ),
                        ),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: const Icon(LucideIcons.play, color: Colors.white, size: 32),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.film, size: 14, color: Colors.white70),
                                const SizedBox(width: 6),
                                Text(
                                  videoAsset.fileName,
                                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholderScreen() {
    return Container(
      color: const Color(0xFF1a1a2e),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.monitorOff, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 8),
            Text('No banner uploaded', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

// ── Media Assets List ──

class _MediaAssetsList extends StatelessWidget {
  final List<MediaAsset> mediaAssets;
  const _MediaAssetsList({required this.mediaAssets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Media Assets', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          if (mediaAssets.isEmpty)
            Text('No media assets uploaded', style: AppTextStyles.bodySmall)
          else
            ...mediaAssets.map((asset) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 48,
                      height: 36,
                      child: asset.fileType.startsWith('image/')
                          ? Image.network(
                              asset.thumbnailUrl ?? asset.fileUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(LucideIcons.image, size: 16, color: AppColors.textTertiary),
                              ),
                            )
                          : Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(LucideIcons.video, size: 16, color: AppColors.textTertiary),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(asset.fileName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                        Text(
                          '${asset.fileType.toUpperCase()} - ${(asset.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

// ── Supporting Widgets ──

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoCard({required this.icon, required this.label, required this.value, required this.color});

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

class _TimelineRow extends StatelessWidget {
  final String label;
  final String value;
  const _TimelineRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
