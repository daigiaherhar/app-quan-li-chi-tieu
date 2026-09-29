import 'package:quan_ly_chi_tieu/core/config/env/app_env.dart';

/// App-facing accessors for compile-time env values.
class KeyConfig {
  KeyConfig._();

  static String get supabaseUrl => AppEnv.supabaseUrl;

  static String get supabaseAnonKey => AppEnv.supabaseAnonKey;
}
