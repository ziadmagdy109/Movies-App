import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fire_base_services.dart';
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {}
class SignUpFailure extends SignUpState {
  final String? error;

  SignUpFailure(this.error);

}

class SignUpCubit extends Cubit<SignUpState> {
  final FireBaseServices _services = FireBaseServices();

  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp(String email, String password) async {
    emit(SignUpLoading());
    final bool success = await _services.signUpWithEmailAndPassword(email, password);
    if (success) {
      emit(SignUpSuccess());
    } else {
      emit(SignUpFailure("Failed to sign up"));
    }
  }

}