import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:record_result/record_result.dart';

void main() {
  group('PickProfilePicState subclasses', () {
    test('PickProfilePicInitial supports equality and has empty props', () {
      const state = PickProfilePicInitial();
      expect(state, const PickProfilePicInitial());
      expect(state.props, <Object?>[]);
    });

    test('PickProfilePicLoading supports equality and has empty props', () {
      const state = PickProfilePicLoading();
      expect(state, const PickProfilePicLoading());
      expect(state.props, <Object?>[]);
    });

    test('PickProfilePicFailure supports equality and has props with failure',
        () {
      final failure = ServerFailure(message: 'Error 1', statusCode: 500);
      final state = PickProfilePicFailure(failure);
      expect(state, PickProfilePicFailure(failure));
      expect(state.props, [failure]);
    });

    test('PickProfilePicLoaded supports equality and has props with message',
        () {
      const message = 'Profile pic uploaded successfully';
      const state = PickProfilePicLoaded(message);
      expect(state, const PickProfilePicLoaded(message));
      expect(state.props, [message]);
    });
  });
}
