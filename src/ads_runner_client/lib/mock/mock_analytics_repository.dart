import '../domain/entities/analytics_data.dart';
import '../domain/entities/dashboard_metrics.dart';
import '../domain/repositories/analytics_repository.dart';
import 'mock_data.dart';

class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.dashboardMetrics;
  }

  @override
  Future<CampaignAnalytics> getCampaignAnalytics(String campaignId, {DateTime? startDate, DateTime? endDate}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.getCampaignAnalytics(campaignId);
  }

  @override
  Future<Map<String, int>> getGeographicData(String campaignId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'Gauteng': 42,
      'Western Cape': 22,
      'KwaZulu-Natal': 18,
      'Eastern Cape': 8,
      'Free State': 5,
      'Other': 5,
    };
  }
}
