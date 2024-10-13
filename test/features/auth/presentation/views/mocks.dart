import 'package:bloc_test/bloc_test.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}
