import '../core/enums/campaign_status.dart';
import '../domain/entities/campaign.dart';
import '../domain/entities/campaign_summary.dart';
import '../domain/repositories/campaign_repository.dart';
import 'mock_data.dart';

class MockCampaignRepository implements CampaignRepository {
  @override
  Future<List<CampaignSummary>> getCampaigns({int page = 1, CampaignStatus? status, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var results = MockData.campaignSummaries;
    if (status != null) results = results.where((c) => c.status == status).toList();
    if (query != null && query.isNotEmpty) {
      results = results.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    return results;
  }

  @override
  Future<Campaign> getCampaignById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.getCampaignDetail(id);
  }

  @override
  Future<Campaign> createCampaign(Campaign campaign) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return campaign;
  }

  @override
  Future<Campaign> updateCampaign(Campaign campaign) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return campaign;
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
