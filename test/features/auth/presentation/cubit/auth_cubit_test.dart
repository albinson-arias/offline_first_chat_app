import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:record_result/record_result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;
  late AuthCubit authCubit;

  setUp(() {
    authRepository = MockAuthRepository();
    authCubit = AuthCubit(authRepository: authRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit signIn', () {
    const email = 'test@example.com';
    const password = 'password123';

    blocTest<AuthCubit, AuthState>(
      'emits [AuthSuccess] when signIn succeeds',
      setUp: () {
        when(
          () => authRepository.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer(
          (_) async => voidSuccess,
        );
      },
      build: () => authCubit,
      act: (cubit) => cubit.signIn(email: email, password: password),
      expect: () => [isA<AuthSuccess>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthError] when signIn fails',
      setUp: () {
        when(
          () => authRepository.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer(
          (_) async => left(
            ServerFailure(message: 'Error signing in', statusCode: '500'),
          ),
        );
      },
      build: () => authCubit,
      act: (cubit) => cubit.signIn(email: email, password: password),
      expect: () => [isA<AuthError>()],
    );
  });

  group('AuthCubit signUp', () {
    const username = 'testuser';
    const email = 'test@example.com';
    const password = 'password123';

    blocTest<AuthCubit, AuthState>(
      'emits [AuthSuccess] when signUp succeeds',
      setUp: () {
        when(
          () => authRepository.createUserWithEmailAndPassword(
            username: username,
            email: email,
            password: password,
          ),
        ).thenAnswer(
          (_) async => voidSuccess,
        );
      },
      build: () => authCubit,
      act: (cubit) =>
          cubit.signUp(username: username, email: email, password: password),
      expect: () => [AuthSuccess()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthError] when signUp fails',
      setUp: () {
        when(
          () => authRepository.createUserWithEmailAndPassword(
            username: username,
            email: email,
            password: password,
          ),
        ).thenAnswer(
          (_) async => left(
            ServerFailure(message: 'Error signing in', statusCode: '500'),
          ),
        );
      },
      build: () => authCubit,
      act: (cubit) =>
          cubit.signUp(username: username, email: email, password: password),
      expect: () => [isA<AuthError>()],
    );
  });
}
