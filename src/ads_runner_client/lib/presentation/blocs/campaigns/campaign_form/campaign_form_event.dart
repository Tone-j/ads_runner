import 'package:equatable/equatable.dart';
import '../../../../core/enums/region_type.dart';

sealed class CampaignFormEvent extends Equatable {
  const CampaignFormEvent();
  @override
  List<Object?> get props => [];
}

class StepChanged extends CampaignFormEvent {
  final int step;
  const StepChanged(this.step);
  @override
  List<Object?> get props => [step];
}

class NameUpdated extends CampaignFormEvent {
  final String name;
  const NameUpdated(this.name);
  @override
  List<Object?> get props => [name];
}

class DescriptionUpdated extends CampaignFormEvent {
  final String description;
  const DescriptionUpdated(this.description);
  @override
  List<Object?> get props => [description];
}

class BannerSelected extends CampaignFormEvent {
  final int mockIndex;
  const BannerSelected(this.mockIndex);
  @override
  List<Object?> get props => [mockIndex];
}

class VideoSelected extends CampaignFormEvent {
  final int mockIndex;
  const VideoSelected(this.mockIndex);
  @override
  List<Object?> get props => [mockIndex];
}

class MediaAssetRemoved extends CampaignFormEvent {
  final String assetId;
  const MediaAssetRemoved(this.assetId);
  @override
  List<Object?> get props => [assetId];
}

class RegionsSelected extends CampaignFormEvent {
  final List<RegionType> regions;
  const RegionsSelected(this.regions);
  @override
  List<Object?> get props => [regions];
}

class ScheduleSet extends CampaignFormEvent {
  final DateTime startDate;
  final DateTime endDate;
  const ScheduleSet({required this.startDate, required this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}

class BudgetSet extends CampaignFormEvent {
  final double budget;
  const BudgetSet(this.budget);
  @override
  List<Object?> get props => [budget];
}

class FormSubmitted extends CampaignFormEvent {
  const FormSubmitted();
}
