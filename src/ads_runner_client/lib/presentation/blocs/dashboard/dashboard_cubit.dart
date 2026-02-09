import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/analytics_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AnalyticsRepository _analyticsRepository;

  DashboardCubit({required AnalyticsRepository analyticsRepository})
      : _analyticsRepository = analyticsRepository,
        super(DashboardInitial());

  Future<void> loadMetrics() async {
    emit(DashboardLoading());
    try {
      final metrics = await _analyticsRepository.getDashboardMetrics();
      emit(DashboardLoaded(metrics));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refreshMetrics() async {
    try {
      final metrics = await _analyticsRepository.getDashboardMetrics();
      emit(DashboardLoaded(metrics));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
