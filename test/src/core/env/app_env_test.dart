import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/env/app_env.dart';

void main() {
  group('AppEnv', () {
    test('Throws exception if an environment variable is missing', () async {
      // Load missing environment variables to simulate a failure
      dotenv
        ..clean()
        ..testLoad(
          fileInput: '''
        ENVIRONMENT=development
      ''',
        );

      expect(() => AppEnv.supabaseUrl, throwsA(isA<TypeError>()));
      expect(() => AppEnv.supabaseAnonKey, throwsA(isA<TypeError>()));
      expect(() => AppEnv.powersyncInstanceUrl, throwsA(isA<TypeError>()));
    });

    test('Loads the correct environment variables', () {
      dotenv
        ..clean()
        // Set up the mock environment variables using dotenv.testLoad
        ..testLoad(
          fileInput: '''
        ENVIRONMENT=development
        SUPABASE_URL=https://example.supabase.co
        SUPABASE_ANON_KEY=anon-key-example
        POWERSYNC_INSTANCE_URL=https://example.powersync.com
      ''',
        );

      // Verify that the environment variables are correctly loaded
      expect(AppEnv.environment, 'development');
      expect(AppEnv.supabaseUrl, 'https://example.supabase.co');
      expect(AppEnv.supabaseAnonKey, 'anon-key-example');
      expect(AppEnv.powersyncInstanceUrl, 'https://example.powersync.com');
    });
  });
}
