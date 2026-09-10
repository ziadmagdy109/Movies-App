import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class SignOutState {}

class SignOutInitial extends SignOutState {}

class SignOutLoading extends SignOutState {}

class SignOutSuccess extends SignOutState {}

class SignOutFailure extends SignOutState {
  final String error;

  SignOutFailure(this.error);
}
class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit() : super(SignOutInitial());

  Future<void> signOut() async {
    try {
      emit(SignOutLoading());

      await FirebaseAuth.instance.signOut();

      emit(SignOutSuccess());
    } catch (e) {
      emit(SignOutFailure(e.toString()));
    }
  }
}