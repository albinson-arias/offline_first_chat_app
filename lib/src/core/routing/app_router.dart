import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/views/login_screen.dart';
import 'package:offline_first_chat_app/features/auth/presentation/views/register_screen.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/chat_page.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/contacts_page.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/rooms_page.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/core/routing/go_router_refresh_stream.dart';

GoRouter getRouter(
  AuthRepository authRepository,
) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    initialLocation: '/',
    redirect: (_, state) async {
      final authState = await authRepository.authStateChanges().first;

      if (authState == LocalAuthState.signedIn &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/register')) {
        return '/';
      }

      if (authState == LocalAuthState.signedOut) {
        if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register') {
          return state.matchedLocation;
        }
        return '/register';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (context, state) => BlocProvider<AuthCubit>(
          create: (context) => sl(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) => BlocProvider<AuthCubit>(
          create: (context) => sl(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        name: AppRoutes.rooms.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RoomsCubit>(
                create: (context) => sl(),
              ),
            ],
            child: const RoomsPage(),
          ),
        ),
        routes: [
          GoRoute(
            path: 'chat/:roomId',
            name: AppRoutes.chat.name,
            builder: (context, state) {
              final room = state.extra! as Room;
              return BlocProvider<ChatCubit>(
                create: (context) => sl()..loadChat(room.id),
                child: ChatPage(room: room),
              );
            },
          ),
          GoRoute(
            path: 'contacts',
            name: AppRoutes.contacts.name,
            builder: (context, state) {
              return BlocProvider<ContactsCubit>(
                create: (context) => sl()..loadContacts(),
                child: const ContactsPage(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>(
                create: (context) => sl(),
              ),
              BlocProvider<PickProfilePicCubit>(
                create: (context) => sl(),
              ),
            ],
            child: const ProfileScreen(),
          ),
        ),
      ),
    ],
  );
}
