import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit() : super(0);
  void navigateToHome() {
    emit(0);
  }

  void navigateToProfile() {
    emit(1);
  }
}
