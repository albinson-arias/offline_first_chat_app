import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:record_result/record_result.dart';

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockGlobalStore extends Mock implements GlobalStore {}

void main() {
  late MockAuthLocalDatasource mockLocalDatasource;
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockGlobalStore mockGlobalStore;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockGlobalStore = MockGlobalStore();

    authRepository = AuthRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      globalStore: mockGlobalStore,
    );
  });

  group('AuthRepositoryImpl Tests', () {
    final testProfile = Profile(
      id: '123',
      username: 'testuser',
      bio: 'Test bio',
      createdAt: DateTime.now(),
    );

    group('createUserWithEmailAndPassword', () {
      test('should return Profile when user is created successfully', () async {
        // Arrange
        when(
          () => mockRemoteDatasource.createUserWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
            username: 'testuser',
          ),
        ).thenAnswer((_) async => testProfile);

        // Act
        final result = await authRepository.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password123',
          username: 'testuser',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfile);
        verify(() => mockGlobalStore.userId = testProfile.id).called(1);
      });

      test('should return Failure when ServerException is thrown', () async {
        // Arrange
        when(
          () => mockRemoteDatasource.createUserWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
            username: 'testuser',
          ),
        ).thenThrow(
          const ServerException(message: 'exception', statusCode: '500'),
        );

        // Act
        final result = await authRepository.createUserWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password123',
          username: 'testuser',
        );

        // Assert
        expect(result.isFailure, isTrue);
        verifyNever(() => mockGlobalStore.userId = any<String>());
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should return Profile when sign in is successful', () async {
        // Arrange
        when(
          () => mockRemoteDatasource.signInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => testProfile);

        // Act
        final result = await authRepository.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password123',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfile);
        verify(() => mockGlobalStore.userId = testProfile.id).called(1);
      });

      test('should return Failure when ServerException is thrown', () async {
        // Arrange
        when(
          () => mockRemoteDatasource.signInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
          ),
        ).thenThrow(
          const ServerException(message: 'exception', statusCode: '500'),
        );

        // Act
        final result = await authRepository.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'password123',
        );

        // Assert
        expect(result.isFailure, isTrue);
        verifyNever(() => mockGlobalStore.userId = any<String>());
      });
    });

    group('getCurrentUser', () {
      test('should return Profile when getCurrentUser is successful', () async {
        // Arrange
        when(() => mockLocalDatasource.getCurrentUser()).thenAnswer(
          (_) async => testProfile,
        );

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfile);
      });

      test('should return Failure when ServerException is thrown', () async {
        // Arrange
        when(() => mockLocalDatasource.getCurrentUser()).thenThrow(
          const ServerException(message: 'exception', statusCode: '500'),
        );

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result.isFailure, isTrue);
      });
    });

    group('signOut', () {
      test('should sign out successfully', () async {
        // Arrange
        when(() => mockRemoteDatasource.signOut()).thenAnswer((_) async {});

        // Act
        final result = await authRepository.signOut();

        // Assert
        expect(result.isSuccess, isTrue);
        verify(() => mockGlobalStore.userId = null).called(1);
      });

      test(
          'should return Failure when ServerException is '
          'thrown during sign out', () async {
        // Arrange
        when(() => mockRemoteDatasource.signOut()).thenThrow(
          const ServerException(message: 'exception', statusCode: '500'),
        );

        // Act
        final result = await authRepository.signOut();

        // Assert
        expect(result.isFailure, isTrue);
      });
    });

    group('get accessToken', () {
      test('should return the access token from the remote data source', () {
        // Arrange
        when(() => mockRemoteDatasource.accessToken)
            .thenReturn('testAccessToken');

        // Act
        final result = authRepository.accessToken;

        // Assert
        expect(result, 'testAccessToken');
        verify(() => mockRemoteDatasource.accessToken).called(1);
      });
    });

    group('authStateChanges', () {
      test(
          'should return a stream of LocalAuthState '
          'from the remote data source', () {
        // Arrange
        final testStream = Stream<LocalAuthState>.fromIterable(
          [LocalAuthState.signedIn, LocalAuthState.signedOut],
        );
        when(() => mockRemoteDatasource.authStateChanges())
            .thenAnswer((_) => testStream);

        // Act
        final result = authRepository.authStateChanges();

        // Assert
        expect(
          result,
          emitsInOrder([LocalAuthState.signedIn, LocalAuthState.signedOut]),
        );
        verify(() => mockRemoteDatasource.authStateChanges()).called(1);
      });
    });

    group('isLoggedIn', () {
      test('should return true if the user is logged in', () {
        // Arrange
        when(() => mockRemoteDatasource.isLoggedIn).thenReturn(true);

        // Act
        final result = authRepository.isLoggedIn;

        // Assert
        expect(result, isTrue);
        verify(() => mockRemoteDatasource.isLoggedIn).called(1);
      });

      test('should return false if the user is not logged in', () {
        // Arrange
        when(() => mockRemoteDatasource.isLoggedIn).thenReturn(false);

        // Act
        final result = authRepository.isLoggedIn;

        // Assert
        expect(result, isFalse);
        verify(() => mockRemoteDatasource.isLoggedIn).called(1);
      });
    });

    group('getCurrentUserStream', () {
      test('should return a stream of Profile from the local data source', () {
        // Arrange
        final testProfileStream = Stream<Profile>.fromIterable([testProfile]);
        when(() => mockLocalDatasource.getCurrentUserStream())
            .thenAnswer((_) => testProfileStream);

        // Act
        final result = authRepository.getCurrentUserStream();

        // Assert
        expect(result, emitsInOrder([testProfile]));
        verify(() => mockLocalDatasource.getCurrentUserStream()).called(1);
      });
    });
  });
}
