import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:record_result/record_result.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  final AuthRepository _authRepository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (isClosed) return;

    result.fold(
      (success) => emit(AuthSuccess()),
      (failure) => emit(AuthError(failure)),
    );
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.createUserWithEmailAndPassword(
      email: email,
      password: password,
      username: username,
    );

    if (isClosed) return;

    result.fold(
      (success) => emit(AuthSuccess()),
      (failure) => emit(AuthError(failure)),
    );
  }
}
