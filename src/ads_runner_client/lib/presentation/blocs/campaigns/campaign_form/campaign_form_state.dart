import 'package:equatable/equatable.dart';
import '../../../../core/enums/region_type.dart';
import '../../../../domain/entities/media_asset.dart';

class CampaignFormState extends Equatable {
  final int currentStep;
  final String name;
  final String description;
  final List<MediaAsset> mediaAssets;
  final bool isUploadingMedia;
  final List<RegionType> selectedRegions;
  final DateTime? startDate;
  final DateTime? endDate;
  final double budget;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const CampaignFormState({
    this.currentStep = 0,
    this.name = '',
    this.description = '',
    this.mediaAssets = const [],
    this.isUploadingMedia = false,
    this.selectedRegions = const [],
    this.startDate,
    this.endDate,
    this.budget = 0,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  CampaignFormState copyWith({
    int? currentStep, String? name, String? description,
    List<MediaAsset>? mediaAssets, bool? isUploadingMedia,
    List<RegionType>? selectedRegions, DateTime? startDate, DateTime? endDate,
    double? budget, bool? isSubmitting, bool? isSuccess, String? error,
  }) {
    return CampaignFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      description: description ?? this.description,
      mediaAssets: mediaAssets ?? this.mediaAssets,
      isUploadingMedia: isUploadingMedia ?? this.isUploadingMedia,
      selectedRegions: selectedRegions ?? this.selectedRegions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [currentStep, name, description, mediaAssets, isUploadingMedia, selectedRegions, startDate, endDate, budget, isSubmitting, isSuccess, error];
}
