import 'package:movies_app/core/gen/assets.gen.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileLoaded extends UpdateProfileState {
  UpdateProfileLoaded({
    required this.name,
    required this.phone,
    required this.avatar,
  });

  final String name;
  final String phone;
  final AssetGenImage avatar;
}

class UpdateProfileSuccess extends UpdateProfileState {
  UpdateProfileSuccess({
    required this.name,
    required this.phone,
    required this.avatar,
  });

  final String name;
  final String phone;
  final AssetGenImage avatar;
}

class UpdateProfileFailure extends UpdateProfileState {
  UpdateProfileFailure(this.error);

  final String error;
}