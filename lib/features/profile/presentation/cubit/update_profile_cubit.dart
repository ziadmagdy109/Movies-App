import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/gen/assets.gen.dart';

import '../../data/models/user_profile.dart';
import '../../data/repository/profile_repository.dart';
import 'update_profile_states.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  final ProfileRepository _repository = ProfileRepository();

  static List<AssetGenImage> get avatars => UserAvatars.avatars;

  static AssetGenImage avatarFromPath(String? path) =>
      UserAvatars.imageFromKeyOrPath(path);

  Future<void> loadProfile() async {
    emit(UpdateProfileLoading());
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No signed-in user');
      }

      final UserProfile? profile = await _repository.getProfile();
      if (profile != null) {
        emit(UpdateProfileLoaded(
          name: profile.name.isEmpty ? (user.displayName ?? '') : profile.name,
          phone: profile.phone,
          avatar: profile.avatar,
        ));
      } else {
        emit(UpdateProfileLoaded(
          name: user.displayName ?? '',
          phone: '',
          avatar: UserAvatars.imageFromKeyOrPath(null),
        ));
      }
    } catch (e) {
      emit(UpdateProfileFailure(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required AssetGenImage avatar,
  }) async {
    emit(UpdateProfileLoading());
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user
            .updateDisplayName(name)
            .timeout(const Duration(seconds: 10));
        await _repository.saveProfile(UserProfile(
          name: name,
          phone: phone,
          avatarKey: UserAvatars.keyFromImage(avatar),
        ));
      }
    } catch (_) {
    }
    emit(UpdateProfileSuccess(name: name, phone: phone, avatar: avatar));
  }
}