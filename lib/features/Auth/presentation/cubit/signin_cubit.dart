import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fire_base_services.dart';
abstract class SignInState {}

class SignInInitial extends SignInState {}
class SignInLoading extends SignInState {}
class SignInSuccess extends SignInState {}
class SignInFailure extends SignInState {
  final String? error;

  SignInFailure(this.error);

}

class SignInCubit extends Cubit<SignInState> {
  final FireBaseServices _services = FireBaseServices();

    SignInCubit() : super(SignInInitial());

  Future<void> signIn(String email, String password) async {
    emit(SignInLoading());
    final bool success = await _services.signInWithEmailAndPassword(email, password);
    if (success) {
      emit(SignInSuccess());
    } else {
      emit(SignInFailure("Failed to sign in"));
    }
  }

}