import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/screen_status.dart';
import '../../../domain/repositories/screen_repository.dart';
import 'screens_state.dart';

class ScreensCubit extends Cubit<ScreensState> {
  final ScreenRepository _screenRepository;

  ScreensCubit({required ScreenRepository screenRepository})
      : _screenRepository = screenRepository,
        super(ScreensInitial());

  Future<void> loadScreens() async {
    emit(ScreensLoading());
    try {
      final screens = await _screenRepository.getScreens();
      emit(ScreensLoaded(screens: screens));
    } catch (e) {
      emit(ScreensError(e.toString()));
    }
  }

  Future<void> filterByStatus(ScreenStatus? status) async {
    emit(ScreensLoading());
    try {
      final screens = await _screenRepository.getScreens(status: status);
      emit(ScreensLoaded(screens: screens, activeFilter: status));
    } catch (e) {
      emit(ScreensError(e.toString()));
    }
  }

  Future<void> searchScreens(String query) async {
    emit(ScreensLoading());
    try {
      final screens = await _screenRepository.getScreens(query: query);
      emit(ScreensLoaded(screens: screens));
    } catch (e) {
      emit(ScreensError(e.toString()));
    }
  }
}
