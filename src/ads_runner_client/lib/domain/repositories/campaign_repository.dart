import '../entities/campaign.dart';
import '../entities/campaign_summary.dart';
import '../../core/enums/campaign_status.dart';

abstract class CampaignRepository {
  Future<List<CampaignSummary>> getCampaigns({int page = 1, CampaignStatus? status, String? query});
  Future<Campaign> getCampaignById(String id);
  Future<Campaign> createCampaign(Campaign campaign);
  Future<Campaign> updateCampaign(Campaign campaign);
  Future<void> deleteCampaign(String id);
}
