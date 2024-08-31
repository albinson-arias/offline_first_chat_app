import 'package:get_it/get_it.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:offline_first_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource_impl.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource_impl.dart';
import 'package:offline_first_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  await initCore();
  await Future.wait([
    initAuth(),
    initChat(),
  ]);
}

Future<void> initCore() async {
  sl
    ..registerLazySingleton<GoTrueClient>(() => Supabase.instance.client.auth)
    ..registerLazySingleton<PostgrestClient>(
      () => Supabase.instance.client.rest,
    );
}

Future<void> initAuth() async {
  sl
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(auth: sl(), database: sl()),
    )
    ..registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(db: sl(), auth: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDatasource: sl(), remoteDatasource: sl()),
    );
}

Future<void> initChat() async {
  sl
    ..registerLazySingleton<ChatRemoteDatasource>(
      () => ChatRemoteDatasourceImpl(auth: sl(), database: sl()),
    )
    ..registerLazySingleton<ChatLocalDatasource>(
      () => ChatLocalDatasourceImpl(db: sl(), auth: sl()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(localDatasource: sl(), remoteDatasource: sl()),
    );
}
