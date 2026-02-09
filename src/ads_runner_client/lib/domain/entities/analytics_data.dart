import 'package:equatable/equatable.dart';

class AnalyticsDataPoint extends Equatable {
  final DateTime date;
  final int impressions;
  final int reach;
  final double revenue;

  const AnalyticsDataPoint({
    required this.date,
    required this.impressions,
    required this.reach,
    required this.revenue,
  });

  @override
  List<Object> get props => [date, impressions, reach, revenue];
}

class CampaignAnalytics extends Equatable {
  final String campaignId;
  final List<AnalyticsDataPoint> dataPoints;
  final int totalImpressions;
  final int totalReach;
  final double ctr;
  final int avgDailyImpressions;

  const CampaignAnalytics({
    required this.campaignId,
    required this.dataPoints,
    required this.totalImpressions,
    required this.totalReach,
    required this.ctr,
    required this.avgDailyImpressions,
  });

  @override
  List<Object> get props => [campaignId, totalImpressions, totalReach];
}
