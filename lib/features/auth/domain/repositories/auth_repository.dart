import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:record_result/record_result.dart';

/// An interface for accessing authentication functionalities.
abstract interface class AuthRepository {
  /// Attempts to sign in the user with the provided email and password.
  FutureResult<Profile> signInWithEmailAndPassword({
    /// The email address of the user.
    required String email,

    /// The user's password.
    required String password,
  });

  /// Attempts to sign in the user with the provided email and password.
  FutureResult<Profile> createUserWithEmailAndPassword({
    /// The email address of the user.
    required String email,

    /// The user's password.
    required String password,

    /// The name of the user.
    required String username,
  });

  /// Signs out the currently authenticated user.
  FutureResultVoid signOut();

  /// Provides a stream of events representing
  /// changes in the authentication state.
  Stream<LocalAuthState> authStateChanges();

  /// Retrieves the user currently logged in.
  FutureResult<Profile> getCurrentUser();

  /// Retrieves the user currently logged in.
  Stream<Profile> getCurrentUserStream();

  /// Returns whether the user is logged in.
  bool get isLoggedIn;

  /// Returns the current access token, null if not logged in
  String? get accessToken;
}
