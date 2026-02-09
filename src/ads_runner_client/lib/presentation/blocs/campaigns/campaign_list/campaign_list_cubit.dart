import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/campaign_status.dart';
import '../../../../domain/repositories/campaign_repository.dart';
import 'campaign_list_state.dart';

class CampaignListCubit extends Cubit<CampaignListState> {
  final CampaignRepository _campaignRepository;

  CampaignListCubit({required CampaignRepository campaignRepository})
      : _campaignRepository = campaignRepository,
        super(CampaignListInitial());

  Future<void> loadCampaigns() async {
    emit(CampaignListLoading());
    try {
      final campaigns = await _campaignRepository.getCampaigns();
      emit(CampaignListLoaded(campaigns: campaigns));
    } catch (e) {
      emit(CampaignListError(e.toString()));
    }
  }

  Future<void> filterByStatus(CampaignStatus? status) async {
    emit(CampaignListLoading());
    try {
      final campaigns = await _campaignRepository.getCampaigns(status: status);
      emit(CampaignListLoaded(campaigns: campaigns, activeFilter: status));
    } catch (e) {
      emit(CampaignListError(e.toString()));
    }
  }

  Future<void> searchCampaigns(String query) async {
    emit(CampaignListLoading());
    try {
      final campaigns = await _campaignRepository.getCampaigns(query: query);
      emit(CampaignListLoaded(campaigns: campaigns, searchQuery: query));
    } catch (e) {
      emit(CampaignListError(e.toString()));
    }
  }

  Future<void> deleteCampaign(String id) async {
    try {
      await _campaignRepository.deleteCampaign(id);
      await loadCampaigns();
    } catch (e) {
      emit(CampaignListError(e.toString()));
    }
  }
}
