import 'dart:async';

import 'package:flutter/foundation.dart';

import 'clinic_cubit.dart';
import 'clinic_state.dart';

class ClinicCubitRefreshListenable extends ChangeNotifier {
  late final StreamSubscription<ClinicState> _sub;

  ClinicCubitRefreshListenable(ClinicCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
