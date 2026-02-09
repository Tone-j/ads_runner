import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/enums/screen_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/screen_device.dart';
import '../../blocs/screens_management/screens_cubit.dart';
import '../../blocs/screens_management/screens_state.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/common/status_badge.dart';

class ScreensMapPage extends StatelessWidget {
  const ScreensMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScreensCubit>()..loadScreens(),
      child: const _ScreensMapView(),
    );
  }
}

class _ScreensMapView extends StatefulWidget {
  const _ScreensMapView();

  @override
  State<_ScreensMapView> createState() => _ScreensMapViewState();
}

class _ScreensMapViewState extends State<_ScreensMapView> {
  ScreenDevice? _selectedScreen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreensCubit, ScreensState>(
      builder: (context, state) {
        if (state is ScreensLoading || state is ScreensInitial) {
          return const LoadingIndicator(message: 'Loading map...');
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
              const PageHeader(
                title: 'Screen Map',
                subtitle: 'Live locations of all screen devices',
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: const LatLng(-26.2041, 28.0473),
                        initialZoom: 12,
                        onTap: (_, __) => setState(() => _selectedScreen = null),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.adsrunner.app',
                        ),
                        MarkerLayer(
                          markers: state.screens.map((screen) => _buildMarker(screen)).toList(),
                        ),
                      ],
                    ),
                    if (_selectedScreen != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _ScreenPopupCard(
                          screen: _selectedScreen!,
                          onClose: () => setState(() => _selectedScreen = null),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _MapLegend(screens: state.screens),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Marker _buildMarker(ScreenDevice screen) {
    final hasCampaigns = screen.assignedCampaignIds.isNotEmpty;
    final size = hasCampaigns ? 36.0 : 26.0;
    final isSelected = _selectedScreen?.id == screen.id;

    return Marker(
      point: LatLng(screen.latitude, screen.longitude),
      width: size + 8,
      height: size + 8,
      child: GestureDetector(
        onTap: () => setState(() => _selectedScreen = screen),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasCampaigns)
              Container(
                width: size + 8,
                height: size + 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: screen.status.color.withValues(alpha: 0.25),
                ),
              ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: screen.status.color,
                border: Border.all(
                  color: isSelected ? Colors.white : screen.status.color,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: screen.status.color.withValues(alpha: 0.5),
                    blurRadius: hasCampaigns ? 10 : 4,
                    spreadRadius: hasCampaigns ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.monitor,
                size: hasCampaigns ? 16 : 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenPopupCard extends StatelessWidget {
  final ScreenDevice screen;
  final VoidCallback onClose;
  const _ScreenPopupCard({required this.screen, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: screen.status.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(LucideIcons.monitor, size: 16, color: screen.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(screen.name, style: AppTextStyles.labelLarge, overflow: TextOverflow.ellipsis),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(4),
                child: const Icon(LucideIcons.x, size: 16, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          _PopupRow(label: 'Plate', value: screen.vehiclePlate),
          const SizedBox(height: 6),
          _PopupRow(label: 'Status', child: StatusBadge(label: screen.status.label, color: screen.status.color)),
          const SizedBox(height: 6),
          _PopupRow(label: 'Firmware', value: screen.firmwareVersion),
          const SizedBox(height: 6),
          _PopupRow(
            label: 'Campaigns',
            value: screen.assignedCampaignIds.isNotEmpty
                ? screen.assignedCampaignIds.join(', ')
                : 'None',
          ),
        ],
      ),
    );
  }
}

class _PopupRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;
  const _PopupRow({required this.label, this.value, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(
          child: child ?? Text(
            value ?? '',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  final List<ScreenDevice> screens;
  const _MapLegend({required this.screens});

  @override
  Widget build(BuildContext context) {
    final statusCounts = <ScreenStatus, int>{};
    for (final s in screens) {
      statusCounts[s.status] = (statusCounts[s.status] ?? 0) + 1;
    }
    final withCampaigns = screens.where((s) => s.assignedCampaignIds.isNotEmpty).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Legend', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              ...ScreenStatus.values.map((status) => _LegendItem(
                color: status.color,
                label: status.label,
                count: statusCounts[status] ?? 0,
              )),
              _LegendItem(
                color: AppColors.primary,
                label: 'With campaigns',
                count: withCampaigns,
                hasGlow: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final bool hasGlow;
  const _LegendItem({required this.color, required this.label, required this.count, this.hasGlow = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: hasGlow
                ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
