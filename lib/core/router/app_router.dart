import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit_refresh_listenable.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/clinic/presentation/cubit/clinic_cubit.dart';
import '../../features/clinic/presentation/cubit/clinic_cubit_refresh_listenable.dart';
import '../../features/clinic/presentation/cubit/clinic_state.dart';
import '../../features/clinic/presentation/pages/clinic_or_join_page.dart';
import '../../features/clinic/presentation/pages/create_clinic_page.dart';
import '../../features/clinic/presentation/pages/join_clinic_page.dart';
import '../../features/clinic/presentation/pages/clinic_selector_page.dart';
import '../../features/clinic/presentation/pages/clinic_settings_page.dart';
import '../../features/clinic/presentation/pages/staff_list_page.dart';
import '../../features/patient/presentation/pages/patient_detail_page.dart';
import '../../features/patient/presentation/pages/patient_form_page.dart';
import '../../features/patient/presentation/pages/patient_list_page.dart';
import '../../features/scheduling/presentation/pages/appointment_detail_page.dart';
import '../../features/scheduling/presentation/pages/appointment_list_page.dart';
import '../../features/scheduling/presentation/pages/appointment_type_form_page.dart';
import '../../features/scheduling/presentation/pages/appointment_type_list_page.dart';
import '../../features/scheduling/presentation/pages/book_appointment_page.dart';
import '../../features/scheduling/presentation/pages/manage_availability_page.dart';
import '../../features/scheduling/presentation/pages/my_day_page.dart';
import '../../features/queue/presentation/pages/check_in_page.dart';
import '../../features/queue/presentation/pages/my_queue_page.dart';
import '../../features/queue/presentation/pages/queue_list_page.dart';
import '../../features/queue/presentation/pages/triage_form_page.dart';
import '../../features/queue/presentation/pages/waiting_room_display_page.dart';
import 'placeholder_pages.dart';
import 'route_names.dart';
import 'scaffold_with_nav_bar.dart';

class AppRouter {
  final AuthCubit _authCubit;
  final AuthCubitRefreshListenable _authRefresh;
  final ClinicCubit _clinicCubit;
  final ClinicCubitRefreshListenable _clinicRefresh;

  AppRouter(
    this._authCubit,
    this._authRefresh,
    this._clinicCubit,
    this._clinicRefresh,
  );

  late final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: Listenable.merge([_authRefresh, _clinicRefresh]),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/welcome',
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: '/clinic-setup',
        name: RouteNames.clinicSetup,
        builder: (context, state) => const ClinicOrJoinPage(),
      ),
      GoRoute(
        path: '/create-clinic',
        name: RouteNames.createClinic,
        builder: (context, state) => const CreateClinicPage(),
      ),
      GoRoute(
        path: '/join-clinic',
        name: RouteNames.joinClinic,
        builder: (context, state) => const JoinClinicPage(),
      ),
      GoRoute(
        path: '/clinic-selector',
        name: RouteNames.clinicSelector,
        builder: (context, state) => const ClinicSelectorPage(),
      ),
      GoRoute(
        path: '/clinic-settings',
        name: RouteNames.clinicSettings,
        builder: (context, state) => const ClinicSettingsPage(),
      ),
      GoRoute(
        path: '/staff-list',
        name: RouteNames.staffList,
        builder: (context, state) => const StaffListPage(),
      ),
      GoRoute(
        path: '/access-denied',
        name: RouteNames.accessDenied,
        builder: (context, state) => const AccessDeniedPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (context, state) => const HomePlaceholderPage(),
                routes: [
                  GoRoute(
                    path: 'patients',
                    name: RouteNames.patientList,
                    builder: (context, state) => const PatientListPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: RouteNames.patientNew,
                        builder: (context, state) => const PatientFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        name: RouteNames.patientDetail,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return PatientDetailPage(patientId: id);
                        },
                        routes: [
                          GoRoute(
                            path: 'edit',
                            name: RouteNames.patientEdit,
                            builder: (context, state) {
                              final id = state.pathParameters['id']!;
                              return PatientFormPage(patientId: id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'appointments',
                    name: RouteNames.appointments,
                    builder: (context, state) =>
                        const AppointmentListPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: RouteNames.bookAppointment,
                        builder: (context, state) =>
                            const BookAppointmentPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        name: RouteNames.appointmentDetail,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return AppointmentDetailPage(appointmentId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'my-day',
                    name: RouteNames.myDay,
                    builder: (context, state) => const MyDayPage(),
                  ),
                  GoRoute(
                    path: 'availability',
                    name: RouteNames.availability,
                    builder: (context, state) {
                      final clinicId =
                          state.uri.queryParameters['clinicId'] ?? '';
                      final providerId =
                          state.uri.queryParameters['providerId'] ?? '';
                      return ManageAvailabilityPage(
                        clinicId: clinicId,
                        providerId: providerId,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'appointment-types',
                    name: RouteNames.appointmentTypes,
                    builder: (context, state) {
                      final clinicId =
                          state.uri.queryParameters['clinicId'] ?? '';
                      return AppointmentTypeListPage(clinicId: clinicId);
                    },
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: RouteNames.appointmentTypeNew,
                        builder: (context, state) {
                          final clinicId =
                              state.uri.queryParameters['clinicId'] ?? '';
                          return AppointmentTypeFormPage(clinicId: clinicId);
                        },
                      ),
                      GoRoute(
                        path: ':id',
                        name: RouteNames.appointmentTypeEdit,
                        builder: (context, state) {
                          final clinicId =
                              state.uri.queryParameters['clinicId'] ?? '';
                          return AppointmentTypeFormPage(clinicId: clinicId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'queue',
                    name: RouteNames.queueList,
                    builder: (context, state) {
                      final clinicId =
                          state.uri.queryParameters['clinicId'] ?? '';
                      final providerId =
                          state.uri.queryParameters['providerId'] ?? '';
                      return QueueListPage(
                          clinicId: clinicId, providerId: providerId);
                    },
                    routes: [
                      GoRoute(
                        path: 'check-in',
                        name: RouteNames.queueCheckIn,
                        builder: (context, state) => const CheckInPage(),
                      ),
                      GoRoute(
                        path: 'check-in/:appointmentId',
                        name: RouteNames.queueCheckInAppointment,
                        builder: (context, state) {
                          final appointmentId =
                              state.pathParameters['appointmentId'];
                          return CheckInPage(appointmentId: appointmentId);
                        },
                      ),
                      GoRoute(
                        path: ':tokenId/triage',
                        name: RouteNames.queueTriage,
                        builder: (context, state) {
                          final tokenId =
                              state.pathParameters['tokenId']!;
                          return TriageFormPage(tokenId: tokenId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'my-queue',
                    name: RouteNames.myQueue,
                    builder: (context, state) => const MyQueuePage(),
                  ),
                  GoRoute(
                    path: 'waiting-room',
                    name: RouteNames.waitingRoom,
                    builder: (context, state) =>
                        const WaitingRoomDisplayPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: RouteNames.settings,
                builder: (context, state) => const SettingsPlaceholderPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final auth = _authCubit.state;
    final clinic = _clinicCubit.state;
    final location = state.matchedLocation;

    // 1. Auth loading — no redirect
    if (auth is AuthInitial || auth is AuthLoading) return null;

    // 2. Not authenticated → welcome
    if (auth is Unauthenticated || auth is AuthError) {
      return location == '/welcome' ? null : '/welcome';
    }

    // 3. Authenticated, no profile → profile setup
    if (auth is Authenticated && auth.profile == null) {
      return location == '/profile-setup' ? null : '/profile-setup';
    }

    // 4. Has profile, no clinic assignments → create/join clinic
    if (auth is Authenticated &&
        clinic is ClinicLoaded &&
        clinic.assignments.isEmpty) {
      const clinicOnboarding = ['/clinic-setup', '/create-clinic', '/join-clinic'];
      return clinicOnboarding.contains(location) ? null : '/clinic-setup';
    }

    // 5. Has multiple clinics, none selected → clinic selector
    if (auth is Authenticated &&
        clinic is ClinicLoaded &&
        clinic.selectedClinicId == null) {
      if (clinic.assignments.length > 1) {
        return location == '/clinic-selector' ? null : '/clinic-selector';
      }
      // Auto-select if only one clinic
      _clinicCubit.selectClinic(clinic.assignments.first.clinicId);
      return null;
    }

    // 6. Fully set up — leave onboarding screens
    if (auth is Authenticated &&
        clinic is ClinicLoaded &&
        clinic.selectedClinicId != null) {
      const onboarding = [
        '/welcome',
        '/profile-setup',
        '/clinic-setup',
        '/create-clinic',
        '/join-clinic',
        '/clinic-selector',
      ];
      if (onboarding.contains(location)) return '/home';
    }

    return null;
  }
}

