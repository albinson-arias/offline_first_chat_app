import 'package:get_it/get_it.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:offline_first_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource_impl.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource_impl.dart';
import 'package:offline_first_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:offline_first_chat_app/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:offline_first_chat_app/features/profile/data/datasources/local/profile_local_datasource_impl.dart';
import 'package:offline_first_chat_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/image_uploader_impl.dart';
import 'package:offline_first_chat_app/src/common/domain/repositories/image_uploader.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  await initCore();
  await Future.wait([
    initAuth(),
    initChat(),
    initProfile(),
  ]);
}

Future<void> initCore() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => getRouter(sl()))
    ..registerSingleton(sharedPreferences)
    ..registerLazySingleton<ImageUploader>(
      () => ImageUploaderImpl(storageClient: sl()),
    )
    ..registerLazySingleton(() => GlobalStore(sharedPreferences: sl()))
    ..registerLazySingleton(BottomNavBarCubit.new)
    ..registerLazySingleton<GoTrueClient>(() => Supabase.instance.client.auth)
    ..registerLazySingleton<SupabaseStorageClient>(
      () => Supabase.instance.client.storage,
    )
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
      () => AuthRepositoryImpl(
        localDatasource: sl(),
        remoteDatasource: sl(),
        globalStore: sl(),
      ),
    )
    ..registerFactory<AuthCubit>(
      () => AuthCubit(authRepository: sl()),
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
    )
    ..registerFactory<RoomsCubit>(
      () => RoomsCubit(chatRepository: sl()),
    )
    ..registerFactory<ChatCubit>(
      () => ChatCubit(chatRepository: sl()),
    )
    ..registerFactory<ContactsCubit>(
      () => ContactsCubit(chatRepository: sl()),
    )
    ..registerFactory<AddContactsCubit>(
      () => AddContactsCubit(chatRepository: sl()),
    );
}

Future<void> initProfile() async {
  sl
    ..registerLazySingleton<ProfileLocalDatasource>(
      () => ProfileLocalDatasourceImpl(db: sl(), auth: sl()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(localDatasource: sl(), imageUploader: sl()),
    )
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(repository: sl()),
    )
    ..registerFactory<PickProfilePicCubit>(
      () => PickProfilePicCubit(repository: sl()),
    );
}
