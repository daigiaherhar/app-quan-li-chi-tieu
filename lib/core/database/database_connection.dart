import 'package:drift/drift.dart';

import 'package:quan_ly_chi_tieu/core/database/database_connection_stub.dart'
    if (dart.library.io) 'package:quan_ly_chi_tieu/core/database/database_connection_native.dart'
    if (dart.library.js_interop) 'package:quan_ly_chi_tieu/core/database/database_connection_web.dart';

QueryExecutor openDatabaseConnection() => connect();
