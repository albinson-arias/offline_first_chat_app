class AppEnv {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const powersyncInstanceUrl = String.fromEnvironment(
    'POWERSYNC_INSTANCE_URL',
  );
}
