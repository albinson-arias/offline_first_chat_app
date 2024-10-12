import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';

void main() {
  group('BottomNavBarCubit', () {
    // Test the initial state
    test('initial state is 0', () {
      expect(BottomNavBarCubit().state, 0);
    });

    // Test for navigateToHome
    blocTest<BottomNavBarCubit, int>(
      'emits [0] when navigateToHome is called',
      build: BottomNavBarCubit.new,
      act: (cubit) => cubit.navigateToHome(),
      expect: () => [0],
    );

    // Test for navigateToProfile
    blocTest<BottomNavBarCubit, int>(
      'emits [1] when navigateToProfile is called',
      build: BottomNavBarCubit.new,
      act: (cubit) => cubit.navigateToProfile(),
      expect: () => [1],
    );
  });
}
