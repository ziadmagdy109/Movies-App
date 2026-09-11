import 'package:bloc/bloc.dart';

import '../../../../core/services/fire_base_services.dart';


sealed class GoogleSignInState {}

final class GoogleSignInInitial extends GoogleSignInState {}

final class GoogleSignInLoading extends GoogleSignInState {}

final class GoogleSignInSuccess extends GoogleSignInState {}

final class GoogleSignInError extends GoogleSignInState {
  final String message;
  GoogleSignInError(this.message);
}

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit() : super(GoogleSignInInitial());

  final FireBaseServices _services = FireBaseServices();
  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    print("Loading..");

    try {
      final userCredential = await _services.signInWithGoogle();

      if (userCredential != null) {
        emit(GoogleSignInSuccess());
        print("Scuess");
      } else {
        emit(GoogleSignInError('Google Sign-In was cancelled or failed'));
        print("Failed");
      }
    } catch (e) {
      emit(GoogleSignInError(e.toString()));
      print("errorr");
    }
  }
}