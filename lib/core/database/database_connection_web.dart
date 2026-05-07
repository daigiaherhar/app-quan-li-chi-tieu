import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor connect() {
  return DatabaseConnection.delayed(
    Future<DatabaseConnection>(() async {
      final WasmDatabaseResult result = await WasmDatabase.open(
        databaseName: 'quan_ly_chi_tieu',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}
