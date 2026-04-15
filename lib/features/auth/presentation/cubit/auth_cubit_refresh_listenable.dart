import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_cubit.dart';
import 'auth_state.dart';

/// Bridges [AuthCubit] state changes to GoRouter's [refreshListenable].
///
/// GoRouter requires a [Listenable] to trigger route re-evaluation. Since
/// [AuthCubit] emits via a [Stream] rather than extending [ChangeNotifier],
/// this bridge listens to the cubit's stream and calls [notifyListeners]
/// on every state change.
class AuthCubitRefreshListenable extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  AuthCubitRefreshListenable(AuthCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
