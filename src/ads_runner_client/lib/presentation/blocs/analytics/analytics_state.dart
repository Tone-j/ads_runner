import 'package:equatable/equatable.dart';
import '../../../domain/entities/analytics_data.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}
class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final CampaignAnalytics analytics;
  final Map<String, int> geographicData;
  final String? selectedCampaignId;

  const AnalyticsLoaded({required this.analytics, required this.geographicData, this.selectedCampaignId});
  @override
  List<Object?> get props => [analytics, geographicData, selectedCampaignId];
}

class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);
  @override
  List<Object?> get props => [message];
}
