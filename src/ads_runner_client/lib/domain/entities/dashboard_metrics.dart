import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final int activeCampaigns;
  final int totalImpressions;
  final int dailyReach;
  final double monthlyRevenue;
  final int onlineScreens;
  final int totalScreens;
  final double impressionsTrend;
  final double reachTrend;
  final double revenueTrend;
  final List<ActivityItem> recentActivity;

  const DashboardMetrics({
    required this.activeCampaigns,
    required this.totalImpressions,
    required this.dailyReach,
    required this.monthlyRevenue,
    required this.onlineScreens,
    required this.totalScreens,
    required this.impressionsTrend,
    required this.reachTrend,
    required this.revenueTrend,
    required this.recentActivity,
  });

  @override
  List<Object> get props => [activeCampaigns, totalImpressions, dailyReach, monthlyRevenue];
}

class ActivityItem extends Equatable {
  final String id;
  final String description;
  final String type;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.description,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, description, type, timestamp];
}
