import 'package:equatable/equatable.dart';
import '../../core/enums/campaign_status.dart';

class CampaignSummary extends Equatable {
  final String id;
  final String name;
  final CampaignStatus status;
  final int impressions;
  final int reach;
  final DateTime startDate;
  final DateTime endDate;
  final String? thumbnailUrl;

  const CampaignSummary({
    required this.id,
    required this.name,
    required this.status,
    required this.impressions,
    required this.reach,
    required this.startDate,
    required this.endDate,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, name, status];
}
