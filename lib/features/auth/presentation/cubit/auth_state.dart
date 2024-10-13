part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.failure);

  final Failure failure;
  @override
  List<Object?> get props => [failure];
}
