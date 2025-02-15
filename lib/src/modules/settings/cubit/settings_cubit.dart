import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';
import 'package:tarsheed/src/modules/settings/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  SettingsRepository settingsRepository = sl();

  Future<void> getProfile() async {
    emit(GetProfileLoadingState());
    final result = await settingsRepository.getProfile();
    result.fold((l) {
      emit(SettingsErrorState(exception: l));
    }, (r) {
      emit(GetProfileSuccessState(user: r));
    });
  }

  Future<void> updateProfile(User user) async {
    emit(UpdateProfileLoadingState());
    final result = await settingsRepository.updateProfile(user);
    result.fold((l) {
      emit(SettingsErrorState(exception: l));
    }, (r) {
      emit(UpdateProfileSuccessState(user: user));
    });
  }
}
