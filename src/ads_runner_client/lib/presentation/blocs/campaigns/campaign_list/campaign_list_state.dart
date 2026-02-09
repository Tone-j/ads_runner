import 'package:equatable/equatable.dart';
import '../../../../core/enums/campaign_status.dart';
import '../../../../domain/entities/campaign_summary.dart';

sealed class CampaignListState extends Equatable {
  const CampaignListState();
  @override
  List<Object?> get props => [];
}

class CampaignListInitial extends CampaignListState {}
class CampaignListLoading extends CampaignListState {}

class CampaignListLoaded extends CampaignListState {
  final List<CampaignSummary> campaigns;
  final CampaignStatus? activeFilter;
  final String searchQuery;

  const CampaignListLoaded({required this.campaigns, this.activeFilter, this.searchQuery = ''});
  @override
  List<Object?> get props => [campaigns, activeFilter, searchQuery];
}

class CampaignListError extends CampaignListState {
  final String message;
  const CampaignListError(this.message);
  @override
  List<Object?> get props => [message];
}
