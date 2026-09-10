import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fire_base_services.dart';



sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errorMessage;
  ForgetPasswordFailure(this.errorMessage);
}

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  final FireBaseServices _services = FireBaseServices();
  Future<void> resetPassword(String email) async {
    emit(ForgetPasswordLoading());
    try {
      await _services.resetPassword(email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}