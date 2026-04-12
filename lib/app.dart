import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Doctors App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: sl<AppRouter>().router,
    );
  }
}
