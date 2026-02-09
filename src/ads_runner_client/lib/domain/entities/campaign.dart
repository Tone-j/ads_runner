import 'package:equatable/equatable.dart';
import '../../core/enums/campaign_status.dart';
import '../../core/enums/region_type.dart';
import 'media_asset.dart';

class Campaign extends Equatable {
  final String id;
  final String name;
  final String description;
  final CampaignStatus status;
  final List<MediaAsset> mediaAssets;
  final List<RegionType> targetRegions;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final int impressions;
  final int reach;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.mediaAssets,
    required this.targetRegions,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.impressions,
    required this.reach,
    this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, status, startDate, endDate, impressions, reach];
}
