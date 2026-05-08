import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/router/app_router.dart';
import 'package:quan_ly_chi_tieu/firebase_options.dart';
import 'package:quan_ly_chi_tieu/shared/widgets/dismiss_key_board.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DismissKeyboard(
      child: MaterialApp.router(
        title: 'Quan Ly Chi Tieu',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const _AppScrollBehavior(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        locale: const Locale('vi', 'VN'),
        routerConfig: ref.watch(appRouterProvider),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColorsStatic.primary),
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}

/// Allows scrolling by dragging with mouse / touch / trackpad on every
/// platform — Flutter's default disables mouse drag on web/desktop.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}
