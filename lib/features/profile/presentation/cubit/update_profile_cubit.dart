import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/gen/assets.gen.dart';

import 'update_profile_states.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  static final List<AssetGenImage> avatars = [
    Assets.images.gamer1,
    Assets.images.gamer11,
    Assets.images.gamer12,
    Assets.images.gamer13,
    Assets.images.gamer14,
    Assets.images.gamer15,
    Assets.images.gamer16,
    Assets.images.gamer17,
    Assets.images.gamer18,
  ];

  static AssetGenImage avatarFromPath(String? path) {
    for (final AssetGenImage avatar in avatars) {
      if (avatar.path == path) return avatar;
    }
    return avatars.first;
  }

  Future<void> loadProfile() async {
    emit(UpdateProfileLoading());
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No signed-in user');
      }

      final DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (document.exists) {
        final data = document.data() as Map<String, dynamic>? ?? const {};
        emit(UpdateProfileLoaded(
          name: data['name'] as String? ?? user.displayName ?? '',
          phone: data['phone'] as String? ?? '',
          avatar: avatarFromPath(data['avatar'] as String?),
        ));
      } else {
        emit(UpdateProfileLoaded(
          name: user.displayName ?? '',
          phone: '',
          avatar: avatars.first,
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
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user.uid)
            .set({
          'name': name,
          'phone': phone,
          'avatar': avatar.path,
        }).timeout(const Duration(seconds: 10));
      }
    } catch (_) {
    }
    emit(UpdateProfileSuccess(name: name, phone: phone, avatar: avatar));
  }
}