import 'package:bloc/bloc.dart';

class LayoutCubit extends Cubit<int> {
  LayoutCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}
