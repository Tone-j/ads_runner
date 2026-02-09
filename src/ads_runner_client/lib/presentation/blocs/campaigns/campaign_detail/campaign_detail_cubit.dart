import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/campaign_repository.dart';
import 'campaign_detail_state.dart';

class CampaignDetailCubit extends Cubit<CampaignDetailState> {
  final CampaignRepository _campaignRepository;

  CampaignDetailCubit({required CampaignRepository campaignRepository})
      : _campaignRepository = campaignRepository,
        super(CampaignDetailInitial());

  Future<void> loadCampaign(String id) async {
    emit(CampaignDetailLoading());
    try {
      final campaign = await _campaignRepository.getCampaignById(id);
      emit(CampaignDetailLoaded(campaign));
    } catch (e) {
      emit(CampaignDetailError(e.toString()));
    }
  }
}
