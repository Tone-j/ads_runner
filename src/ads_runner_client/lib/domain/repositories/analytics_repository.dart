import '../entities/analytics_data.dart';
import '../entities/dashboard_metrics.dart';

abstract class AnalyticsRepository {
  Future<DashboardMetrics> getDashboardMetrics();
  Future<CampaignAnalytics> getCampaignAnalytics(String campaignId, {DateTime? startDate, DateTime? endDate});
  Future<Map<String, int>> getGeographicData(String campaignId);
}
