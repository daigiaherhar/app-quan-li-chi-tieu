import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

QueryExecutor connect() {
  return LazyDatabase(() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final File databaseFile = File(
      path.join(documentsDirectory.path, 'quan_ly_chi_tieu.sqlite'),
    );
    return NativeDatabase.createInBackground(databaseFile);
  });
}
