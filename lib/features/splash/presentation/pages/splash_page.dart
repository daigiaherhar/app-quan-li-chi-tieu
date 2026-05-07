import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/core/constants/constants.dart';
import 'package:quan_ly_chi_tieu/core/router/app_route_paths.dart';
import 'package:quan_ly_chi_tieu/core/utils/size_utils.dart';
import 'package:quan_ly_chi_tieu/features/profile/presentation/providers/profile_providers.dart';

/// Shows branding while session state loads, then navigates home.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  static const Duration _minDisplay = Duration(milliseconds: 450);
  bool _hasError = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    if (_isBusy) {
      return;
    }
    setState(() {
      _hasError = false;
      _isBusy = true;
    });
    try {
      await Future.wait(<Future<void>>[
        ref.read(hasUserInfoProvider.future).then((_) {}),
        Future<void>.delayed(_minDisplay),
      ]);
      if (!mounted) {
        return;
      }
      context.go(AppRoutePaths.home);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _hasError = true;
        _isBusy = false;
      });
    }
  }

  void _onRetry() {
    ref.invalidate(hasUserInfoProvider);
    _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: context.padding.h24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: context.textStyles.h2.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                context.gap.h24,
                if (_hasError) ...<Widget>[
                  Text(
                    AppStrings.errorGeneric,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  context.gap.h16,
                  FilledButton(
                    onPressed: _isBusy ? null : _onRetry,
                    child: const Text(AppStrings.splashRetry),
                  ),
                ] else
                  SizedBox(
                    width: 32.w(context),
                    height: 32.w(context),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: context.colors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
