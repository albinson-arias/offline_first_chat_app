import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';

abstract interface class AuthRemoteDatasource {
  Future<Profile> signInWithEmailAndPassword({
    /// The email address of the user.
    required String email,

    /// The user's password.
    required String password,
  });

  Future<Profile> createUserWithEmailAndPassword({
    /// The email address of the user.
    required String email,

    /// The user's password.
    required String password,

    /// The name of the user.
    required String username,
  });

  Future<void> signOut();

  Stream<LocalAuthState> authStateChanges();

  bool get isLoggedIn;

  String? get accessToken;
}
