import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/media_asset.dart';
import '../../../../mock/mock_media_gallery.dart';
import 'campaign_form_event.dart';
import 'campaign_form_state.dart';

class CampaignFormBloc extends Bloc<CampaignFormEvent, CampaignFormState> {
  CampaignFormBloc() : super(const CampaignFormState()) {
    on<StepChanged>((event, emit) => emit(state.copyWith(currentStep: event.step)));
    on<NameUpdated>((event, emit) => emit(state.copyWith(name: event.name)));
    on<DescriptionUpdated>((event, emit) => emit(state.copyWith(description: event.description)));
    on<BannerSelected>(_onBannerSelected);
    on<VideoSelected>(_onVideoSelected);
    on<MediaAssetRemoved>(_onMediaAssetRemoved);
    on<RegionsSelected>((event, emit) => emit(state.copyWith(selectedRegions: event.regions)));
    on<ScheduleSet>((event, emit) => emit(state.copyWith(startDate: event.startDate, endDate: event.endDate)));
    on<BudgetSet>((event, emit) => emit(state.copyWith(budget: event.budget)));
    on<FormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onBannerSelected(BannerSelected event, Emitter<CampaignFormState> emit) async {
    emit(state.copyWith(isUploadingMedia: true));
    await Future.delayed(const Duration(milliseconds: 600));
    final banner = MockMediaGallery.banners[event.mockIndex];
    final updated = List<MediaAsset>.from(state.mediaAssets)
      ..removeWhere((a) => a.fileType.startsWith('image/'))
      ..add(banner);
    emit(state.copyWith(mediaAssets: updated, isUploadingMedia: false));
  }

  Future<void> _onVideoSelected(VideoSelected event, Emitter<CampaignFormState> emit) async {
    emit(state.copyWith(isUploadingMedia: true));
    await Future.delayed(const Duration(milliseconds: 800));
    final video = MockMediaGallery.videos[event.mockIndex];
    final updated = List<MediaAsset>.from(state.mediaAssets)
      ..removeWhere((a) => a.fileType.startsWith('video/'))
      ..add(video);
    emit(state.copyWith(mediaAssets: updated, isUploadingMedia: false));
  }

  void _onMediaAssetRemoved(MediaAssetRemoved event, Emitter<CampaignFormState> emit) {
    final updated = state.mediaAssets.where((a) => a.id != event.assetId).toList();
    emit(state.copyWith(mediaAssets: updated));
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<CampaignFormState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
