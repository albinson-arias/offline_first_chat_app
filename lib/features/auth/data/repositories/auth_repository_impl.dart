import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:record_result/record_result.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDatasource localDatasource,
    required AuthRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  @override
  String? get accessToken => _remoteDatasource.accessToken;

  @override
  Stream<LocalAuthState> authStateChanges() =>
      _remoteDatasource.authStateChanges();

  @override
  FutureResult<Profile> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final result = await _remoteDatasource.createUserWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );

      return right(result);
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }

  @override
  FutureResult<Profile> getCurrentUser() async {
    try {
      final result = await _localDatasource.getCurrentUser();

      return right(result);
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }

  @override
  bool get isLoggedIn => _remoteDatasource.isLoggedIn;

  @override
  FutureResult<Profile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDatasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(result);
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }

  @override
  FutureResultVoid signOut() async {
    try {
      await _remoteDatasource.signOut();

      return voidSuccess;
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }
}
