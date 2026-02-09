import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/screen_device.dart';
import '../../../domain/repositories/screen_repository.dart';
import '../../router/route_paths.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class ScreenDetailPage extends StatefulWidget {
  final String screenId;
  const ScreenDetailPage({super.key, required this.screenId});

  @override
  State<ScreenDetailPage> createState() => _ScreenDetailPageState();
}

class _ScreenDetailPageState extends State<ScreenDetailPage> {
  late Future<ScreenDevice> _screenFuture;

  @override
  void initState() {
    super.initState();
    _screenFuture = sl<ScreenRepository>().getScreenById(widget.screenId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScreenDevice>(
      future: _screenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator(message: 'Loading screen details...');
        }
        if (snapshot.hasError) {
          return ErrorDisplay(message: snapshot.error.toString());
        }
        final screen = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: screen.name,
              subtitle: screen.vehiclePlate,
              actions: [
                OutlinedButton.icon(
                  onPressed: () => context.go(RoutePaths.screens),
                  icon: const Icon(LucideIcons.arrowLeft, size: 16),
                  label: const Text('Back'),
                ),
              ],
            ),
            Row(
              children: [
                StatusBadge(label: screen.status.label, color: screen.status.color),
                const SizedBox(width: 12),
                Text('Last seen: ${screen.lastSeen.timeAgo}', style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 24),
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
                  Text('Device Information', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  _DetailRow(icon: LucideIcons.hash, label: 'Device ID', value: screen.id),
                  _DetailRow(icon: LucideIcons.car, label: 'Vehicle Plate', value: screen.vehiclePlate),
                  _DetailRow(icon: LucideIcons.cpu, label: 'Firmware', value: screen.firmwareVersion),
                  _DetailRow(icon: LucideIcons.mapPin, label: 'Location', value: '${screen.latitude.toStringAsFixed(4)}, ${screen.longitude.toStringAsFixed(4)}'),
                  _DetailRow(icon: LucideIcons.clock, label: 'Last Seen', value: screen.lastSeen.toFullDateTime()),
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
                  Text('Assigned Campaigns', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  if (screen.assignedCampaignIds.isEmpty)
                    Text('No campaigns assigned', style: AppTextStyles.bodySmall)
                  else
                    ...screen.assignedCampaignIds.map((id) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => context.go('/campaigns/$id'),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.megaphone, size: 14, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(id, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.externalLink, size: 12, color: AppColors.textTertiary),
                          ],
                        ),
                      ),
                    )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 12),
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
