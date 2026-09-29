import 'package:envied/envied.dart';

part 'app_env.g.dart';

@Envied(path: '.env')
abstract final class AppEnv {
  @EnviedField(varName: 'SUPABASE_URL', defaultValue: '')
  static const String supabaseUrl = _AppEnv.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', defaultValue: '', obfuscate: true)
  static final String supabaseAnonKey = _AppEnv.supabaseAnonKey;
}
