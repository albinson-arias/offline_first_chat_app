import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:offline_first_chat_app/src/supabase/database_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({
    required GoTrueClient auth,
    required PostgrestClient database,
  })  : _auth = auth,
        _database = database;

  final GoTrueClient _auth;
  final PostgrestClient _database;

  @override
  String? get accessToken {
    final at = _auth.currentSession?.accessToken;
    return at;
  }

  @override
  bool get isLoggedIn => accessToken != null;

  @override
  Stream<LocalAuthState> authStateChanges() {
    return _auth.onAuthStateChange.map(
      (event) {
        if (event.event == AuthChangeEvent.signedIn) {
          return LocalAuthState.signedIn;
        } else if (event.event == AuthChangeEvent.initialSession &&
            event.session != null) {
          return LocalAuthState.signedIn;
        }
        return LocalAuthState.signedOut;
      },
    );
  }

  @override
  Future<Profile> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final result = await _auth.signUp(
        password: password,
        email: email,
      );

      if (result.session == null) {
        throw const ServerException(
          message: "Couldn't get session",
          statusCode: '505',
        );
      }

      final id = result.session!.user.id;

      final data = await _database
          .from(DatabaseConstants.profilesTable)
          .insert(
            Profile(
              id: id,
              createdAt: DateTime.now(),
              username: username,
            ).toMap(),
          )
          .select()
          .single();

      return ProfileMapper.fromMap(data);
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code ?? '505',
      );
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.statusCode ?? '505',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<Profile> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (result.session == null) {
        throw const ServerException(
          message: "Couldn't get session",
          statusCode: '505',
        );
      }

      final id = result.session!.user.id;

      final userData = await _database
          .from(DatabaseConstants.profilesTable)
          .select()
          .eq('id', id)
          .limit(1)
          .single();

      return ProfileMapper.fromMap(userData);
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code ?? '505',
      );
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.statusCode ?? '505',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.statusCode ?? '505',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
