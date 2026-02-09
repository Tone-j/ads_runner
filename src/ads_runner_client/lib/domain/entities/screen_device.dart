import 'package:equatable/equatable.dart';
import '../../core/enums/screen_status.dart';

class ScreenDevice extends Equatable {
  final String id;
  final String name;
  final String vehiclePlate;
  final double latitude;
  final double longitude;
  final ScreenStatus status;
  final DateTime lastSeen;
  final String firmwareVersion;
  final List<String> assignedCampaignIds;

  const ScreenDevice({
    required this.id,
    required this.name,
    required this.vehiclePlate,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastSeen,
    required this.firmwareVersion,
    required this.assignedCampaignIds,
  });

  @override
  List<Object> get props => [id, name, vehiclePlate, status];
}
