import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static final String environment = dotenv.env['ENVIRONMENT']!;
  static final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  static final String powersyncInstanceUrl =
      dotenv.env['POWERSYNC_INSTANCE_URL']!;
}
