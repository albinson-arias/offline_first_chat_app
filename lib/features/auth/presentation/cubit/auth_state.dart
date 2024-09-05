part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.failure);

  final Failure failure;
}
