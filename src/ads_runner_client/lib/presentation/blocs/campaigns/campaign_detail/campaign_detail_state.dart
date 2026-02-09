import 'package:equatable/equatable.dart';
import '../../../../domain/entities/campaign.dart';

sealed class CampaignDetailState extends Equatable {
  const CampaignDetailState();
  @override
  List<Object?> get props => [];
}

class CampaignDetailInitial extends CampaignDetailState {}
class CampaignDetailLoading extends CampaignDetailState {}

class CampaignDetailLoaded extends CampaignDetailState {
  final Campaign campaign;
  const CampaignDetailLoaded(this.campaign);
  @override
  List<Object?> get props => [campaign];
}

class CampaignDetailError extends CampaignDetailState {
  final String message;
  const CampaignDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
