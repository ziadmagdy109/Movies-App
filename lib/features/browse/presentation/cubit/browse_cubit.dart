import 'package:bloc/bloc.dart';

class BrowseCubit extends Cubit<int> {
  BrowseCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}
