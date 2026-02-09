import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/analytics_repository.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsCubit({required AnalyticsRepository analyticsRepository})
      : _analyticsRepository = analyticsRepository,
        super(AnalyticsInitial());

  Future<void> loadAnalytics([String? campaignId]) async {
    emit(AnalyticsLoading());
    try {
      final id = campaignId ?? 'cmp_001';
      final analytics = await _analyticsRepository.getCampaignAnalytics(id);
      final geoData = await _analyticsRepository.getGeographicData(id);
      emit(AnalyticsLoaded(analytics: analytics, geographicData: geoData, selectedCampaignId: id));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
