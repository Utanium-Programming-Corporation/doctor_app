import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/clinic/presentation/cubit/clinic_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<ClinicCubit>.value(value: sl<ClinicCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Doctors App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: sl<AppRouter>().router,
      ),
    );
  }
}

