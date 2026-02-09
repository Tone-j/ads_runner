import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/enums/region_type.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/media_asset.dart';
import '../../../mock/mock_media_gallery.dart';
import '../../blocs/campaigns/campaign_form/campaign_form_bloc.dart';
import '../../blocs/campaigns/campaign_form/campaign_form_event.dart';
import '../../blocs/campaigns/campaign_form/campaign_form_state.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/page_header.dart';

class CampaignFormPage extends StatelessWidget {
  final bool isEditing;
  const CampaignFormPage({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CampaignFormBloc, CampaignFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Campaign updated' : 'Campaign created'),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(RoutePaths.campaigns);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: isEditing ? 'Edit Campaign' : 'New Campaign',
              subtitle: _stepLabel(state.currentStep),
              actions: [
                OutlinedButton.icon(
                  onPressed: () => context.go(RoutePaths.campaigns),
                  icon: const Icon(LucideIcons.x, size: 16),
                  label: const Text('Cancel'),
                ),
              ],
            ),
            _StepIndicator(currentStep: state.currentStep),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildStepContent(context, state),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (state.currentStep > 0)
                  OutlinedButton(
                    onPressed: () => context.read<CampaignFormBloc>().add(StepChanged(state.currentStep - 1)),
                    child: const Text('Previous'),
                  ),
                const SizedBox(width: 12),
                if (state.currentStep < 4)
                  ElevatedButton(
                    onPressed: () => context.read<CampaignFormBloc>().add(StepChanged(state.currentStep + 1)),
                    child: const Text('Next'),
                  )
                else
                  ElevatedButton(
                    onPressed: state.isSubmitting ? null : () => context.read<CampaignFormBloc>().add(const FormSubmitted()),
                    child: state.isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(isEditing ? 'Update Campaign' : 'Create Campaign'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _stepLabel(int step) {
    switch (step) {
      case 0: return 'Step 1: Basic Information';
      case 1: return 'Step 2: Media Assets';
      case 2: return 'Step 3: Target Regions';
      case 3: return 'Step 4: Schedule';
      case 4: return 'Step 5: Budget & Review';
      default: return '';
    }
  }

  Widget _buildStepContent(BuildContext context, CampaignFormState state) {
    switch (state.currentStep) {
      case 0: return _BasicInfoStep(state: state);
      case 1: return _MediaStep(state: state);
      case 2: return _RegionsStep(state: state);
      case 3: return _ScheduleStep(state: state);
      case 4: return _BudgetStep(state: state);
      default: return const SizedBox.shrink();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Info', 'Media', 'Regions', 'Schedule', 'Budget'];
    return Row(
      children: steps.asMap().entries.map((entry) {
        final isActive = entry.key <= currentStep;
        final isCurrent = entry.key == currentStep;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: AppColors.primaryLight, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entry.key < steps.length - 1)
                Container(
                  width: 24,
                  height: 1,
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _BasicInfoStep extends StatelessWidget {
  final CampaignFormState state;
  const _BasicInfoStep({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Campaign Details', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.name,
          onChanged: (v) => context.read<CampaignFormBloc>().add(NameUpdated(v)),
          decoration: const InputDecoration(labelText: 'Campaign Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.description,
          onChanged: (v) => context.read<CampaignFormBloc>().add(DescriptionUpdated(v)),
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
        ),
      ],
    );
  }
}

// ── Media Step ──

class _MediaStep extends StatelessWidget {
  final CampaignFormState state;
  const _MediaStep({required this.state});

  @override
  Widget build(BuildContext context) {
    final bannerAsset = state.mediaAssets
        .where((a) => a.fileType.startsWith('image/'))
        .cast<MediaAsset?>()
        .firstOrNull;
    final videoAsset = state.mediaAssets
        .where((a) => a.fileType.startsWith('video/'))
        .cast<MediaAsset?>()
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Media Assets', style: AppTextStyles.h4),
        const SizedBox(height: 8),
        Text(
          'Upload a banner image and optional video for your campaign.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 24),

        // Banner section
        Text('Banner Image', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        if (bannerAsset != null)
          _MediaPreviewCard(
            asset: bannerAsset,
            onRemove: () => context.read<CampaignFormBloc>().add(MediaAssetRemoved(bannerAsset.id)),
          )
        else
          _MediaUploadZone(
            icon: LucideIcons.image,
            label: 'Select Banner Image',
            subtitle: 'Recommended: 1920 x 1080px, JPG or PNG',
            onTap: () => _showBannerPicker(context),
          ),
        const SizedBox(height: 24),

        // Video section
        Text('Video (Optional)', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        if (videoAsset != null)
          _MediaPreviewCard(
            asset: videoAsset,
            isVideo: true,
            onRemove: () => context.read<CampaignFormBloc>().add(MediaAssetRemoved(videoAsset.id)),
          )
        else
          _MediaUploadZone(
            icon: LucideIcons.video,
            label: 'Select Video',
            subtitle: 'Max 45 seconds, MP4 format',
            onTap: () => _showVideoPicker(context),
          ),

        if (state.isUploadingMedia) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(height: 8),
          Center(child: Text('Uploading...', style: AppTextStyles.caption)),
        ],
      ],
    );
  }

  void _showBannerPicker(BuildContext context) {
    final bloc = context.read<CampaignFormBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => _MockMediaPickerDialog(
        title: 'Select a Banner',
        assets: MockMediaGallery.banners,
        onSelected: (index) {
          bloc.add(BannerSelected(index));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showVideoPicker(BuildContext context) {
    final bloc = context.read<CampaignFormBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => _MockMediaPickerDialog(
        title: 'Select a Video',
        assets: MockMediaGallery.videos,
        isVideo: true,
        onSelected: (index) {
          bloc.add(VideoSelected(index));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}

class _MediaUploadZone extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _MediaUploadZone({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(label, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaPreviewCard extends StatelessWidget {
  final MediaAsset asset;
  final bool isVideo;
  final VoidCallback onRemove;
  const _MediaPreviewCard({required this.asset, this.isVideo = false, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  asset.thumbnailUrl ?? asset.fileUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: AppColors.surfaceVariant,
                    child: const Icon(LucideIcons.imageOff, color: AppColors.textTertiary, size: 40),
                  ),
                ),
                if (isVideo)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.play, color: Colors.white, size: 28),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  isVideo ? LucideIcons.video : LucideIcons.image,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(asset.fileName, style: AppTextStyles.labelLarge),
                      Text(
                        '${(asset.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.error),
                  onPressed: onRemove,
                  tooltip: 'Remove',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockMediaPickerDialog extends StatelessWidget {
  final String title;
  final List<MediaAsset> assets;
  final bool isVideo;
  final ValueChanged<int> onSelected;
  const _MockMediaPickerDialog({required this.title, required this.assets, this.isVideo = false, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTextStyles.h4),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Choose from sample assets (demo mode)', style: AppTextStyles.caption),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 16 / 10,
                  ),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return InkWell(
                      onTap: () => onSelected(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                asset.thumbnailUrl ?? asset.fileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceVariant,
                                  child: const Icon(LucideIcons.imageOff, color: AppColors.textTertiary),
                                ),
                              ),
                              if (isVideo)
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(LucideIcons.play, color: Colors.white, size: 20),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: Colors.black54,
                                  child: Text(
                                    asset.fileName,
                                    style: AppTextStyles.caption.copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Regions Step ──

class _RegionsStep extends StatelessWidget {
  final CampaignFormState state;
  const _RegionsStep({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Regions', style: AppTextStyles.h4),
        const SizedBox(height: 8),
        Text('Select the regions where your ads will be displayed.', style: AppTextStyles.bodySmall),
        const SizedBox(height: 16),
        Text('Provinces', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        ...RegionType.provinces.map((region) => CheckboxListTile(
          title: Text(region.displayName, style: AppTextStyles.bodyMedium),
          value: state.selectedRegions.contains(region),
          activeColor: AppColors.primary,
          dense: true,
          onChanged: (checked) {
            final regions = List<RegionType>.from(state.selectedRegions);
            if (checked == true) {
              regions.add(region);
            } else {
              regions.remove(region);
            }
            context.read<CampaignFormBloc>().add(RegionsSelected(regions));
          },
        )),
        const SizedBox(height: 16),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        Text('Metropolitan Areas', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        ...RegionType.metros.map((region) => CheckboxListTile(
          title: Text(region.displayName, style: AppTextStyles.bodyMedium),
          value: state.selectedRegions.contains(region),
          activeColor: AppColors.primary,
          dense: true,
          onChanged: (checked) {
            final regions = List<RegionType>.from(state.selectedRegions);
            if (checked == true) {
              regions.add(region);
            } else {
              regions.remove(region);
            }
            context.read<CampaignFormBloc>().add(RegionsSelected(regions));
          },
        )),
      ],
    );
  }
}

// ── Schedule Step ──

class _ScheduleStep extends StatelessWidget {
  final CampaignFormState state;
  const _ScheduleStep({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Campaign Schedule', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DatePickerField(
                label: 'Start Date',
                date: state.startDate,
                onPicked: (d) {
                  final end = state.endDate ?? d.add(const Duration(days: 30));
                  context.read<CampaignFormBloc>().add(ScheduleSet(startDate: d, endDate: end));
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DatePickerField(
                label: 'End Date',
                date: state.endDate,
                onPicked: (d) {
                  final start = state.startDate ?? DateTime.now();
                  context.read<CampaignFormBloc>().add(ScheduleSet(startDate: start, endDate: d));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onPicked;
  const _DatePickerField({required this.label, this.date, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(LucideIcons.calendar, size: 16, color: AppColors.textTertiary),
        ),
        child: Text(
          date != null ? '${date!.month}/${date!.day}/${date!.year}' : 'Select date',
          style: TextStyle(color: date != null ? AppColors.textPrimary : AppColors.textTertiary, fontSize: 14),
        ),
      ),
    );
  }
}

// ── Budget & Review Step ──

class _BudgetStep extends StatelessWidget {
  final CampaignFormState state;
  const _BudgetStep({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Budget', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: state.budget > 0 ? state.budget.toStringAsFixed(0) : '',
          keyboardType: TextInputType.number,
          onChanged: (v) {
            final budget = double.tryParse(v) ?? 0;
            context.read<CampaignFormBloc>().add(BudgetSet(budget));
          },
          decoration: const InputDecoration(
            labelText: 'Budget (ZAR)',
            prefixText: 'R ',
          ),
        ),
        const SizedBox(height: 24),
        Text('Review', style: AppTextStyles.h4),
        const SizedBox(height: 12),
        _ReviewRow(label: 'Name', value: state.name.isNotEmpty ? state.name : '-'),
        _ReviewRow(
          label: 'Media',
          value: state.mediaAssets.isNotEmpty
              ? state.mediaAssets.map((a) => a.fileName).join(', ')
              : 'No media selected',
        ),
        _ReviewRow(label: 'Regions', value: state.selectedRegions.isNotEmpty ? state.selectedRegions.map((r) => r.displayName).join(', ') : '-'),
        _ReviewRow(
          label: 'Schedule',
          value: state.startDate != null && state.endDate != null
              ? '${state.startDate!.month}/${state.startDate!.day}/${state.startDate!.year} - ${state.endDate!.month}/${state.endDate!.day}/${state.endDate!.year}'
              : '-',
        ),
        _ReviewRow(label: 'Budget', value: state.budget > 0 ? 'R${state.budget.toStringAsFixed(0)}' : '-'),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
