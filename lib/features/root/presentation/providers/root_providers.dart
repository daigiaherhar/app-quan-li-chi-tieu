import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/providers/root_notifier.dart';
import 'package:quan_ly_chi_tieu/features/root/presentation/providers/root_state.dart';

final NotifierProvider<RootNotifier, RootState> rootProvider =
    NotifierProvider<RootNotifier, RootState>(RootNotifier.new);
