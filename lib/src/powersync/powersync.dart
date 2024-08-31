import 'package:offline_first_chat_app/src/core/env/app_env.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/database/database_constants.dart';
import 'package:offline_first_chat_app/src/powersync/powersync_schema.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Postgres Response codes that we cannot recover from by retrying.
final List<RegExp> fatalResponseCodes = [
  // Class 22 — Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 — Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

Future<String> getDatabasePath() async {
  final dir = await getApplicationSupportDirectory();
  return join(dir.path, 'powersync.db');
}

bool isLoggedIn() {
  final at = Supabase.instance.client.auth.currentSession?.accessToken;
  return at != null;
}

Future<void> openDatabase() async {
  final db = PowerSyncDatabase(
    schema: schema,
    path: await getDatabasePath(),
  );

  sl.registerSingleton<PowerSyncDatabase>(db);

  await db.initialize();

  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
  );

  SupabaseConnector? currentConnector;

  if (isLoggedIn()) {
    currentConnector = SupabaseConnector();
    await db.connect(connector: currentConnector);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      currentConnector = SupabaseConnector();
      await db.connect(connector: currentConnector!);
    } else if (event == AuthChangeEvent.signedOut) {
      currentConnector = null;
      await db.disconnect();
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      await currentConnector?.prefetchCredentials();
    }
  });
}

class SupabaseConnector extends PowerSyncBackendConnector {
  SupabaseConnector();

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      // not logged in
      return null;
    }

    final token = session.accessToken;

    return PowerSyncCredentials(
      endpoint: AppEnv.powersyncInstanceUrl,
      token: token,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    final rest = Supabase.instance.client.rest;

    try {
      for (final op in transaction.crud) {
        final table = rest.from(op.table);
        if (op.op == UpdateType.put) {
          if (op.table == DatabaseConstants.messagesTable) {
            final data = Map<String, dynamic>.of(op.opData!);
            data['id'] = op.id;
            data['status'] = 1;
            await table.upsert(data);
          } else {
            final data = Map<String, dynamic>.of(op.opData!);
            data['id'] = op.id;
            await table.upsert(data);
          }
        } else if (op.op == UpdateType.patch) {
          await table.update(op.opData!).eq('id', op.id);
        } else if (op.op == UpdateType.delete) {
          await table.delete().eq('id', op.id);
        }
      }

      await transaction.complete();
    } on PostgrestException catch (e) {
      if (e.code != null &&
          fatalResponseCodes.any((re) => re.hasMatch(e.code!))) {
        await transaction.complete();
      } else {
        rethrow;
      }
    }
  }
}
