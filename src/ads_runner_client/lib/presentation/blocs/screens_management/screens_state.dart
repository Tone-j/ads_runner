import 'package:equatable/equatable.dart';
import '../../../core/enums/screen_status.dart';
import '../../../domain/entities/screen_device.dart';

sealed class ScreensState extends Equatable {
  const ScreensState();
  @override
  List<Object?> get props => [];
}

class ScreensInitial extends ScreensState {}
class ScreensLoading extends ScreensState {}

class ScreensLoaded extends ScreensState {
  final List<ScreenDevice> screens;
  final ScreenStatus? activeFilter;

  const ScreensLoaded({required this.screens, this.activeFilter});
  @override
  List<Object?> get props => [screens, activeFilter];
}

class ScreensError extends ScreensState {
  final String message;
  const ScreensError(this.message);
  @override
  List<Object?> get props => [message];
}
