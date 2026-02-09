import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepository _userRepository;

  SettingsCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SettingsInitial());

  Future<void> loadProfile() async {
    emit(SettingsLoading());
    try {
      final profile = await _userRepository.getProfile();
      emit(SettingsLoaded(profile: profile));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateProfile({String? firstName, String? lastName, String? phone}) async {
    try {
      final profile = await _userRepository.updateProfile(firstName: firstName, lastName: lastName, phone: phone);
      emit(SettingsLoaded(profile: profile));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
