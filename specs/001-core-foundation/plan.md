# Implementation Plan: Core Foundation

**Branch**: `001-core-foundation` | **Date**: 2026-04-07 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-core-foundation/spec.md`

## Summary

Establish the core infrastructure layer of the Doctors App: global error handling via `runZonedGuarded` + `FlutterError.onError`, GetIt dependency injection container with per-feature registration, GoRouter configuration with auth/role redirect guards and nested shell routes, base `Failure`/`Exception` types with `Either<Failure, T>` (Dartz), an abstract `UseCase` class, Supabase client singleton initialization via `flutter_dotenv`, and a connectivity-aware `NetworkInfo` utility — all wired together in a restructured `main.dart`.

## Technical Context

**Language/Version**: Dart 3.11.4+ / Flutter (latest stable)
**Primary Dependencies**: `go_router`, `get_it`, `dartz`, `equatable`, `supabase_flutter`, `flutter_bloc`, `connectivity_plus`, `flutter_dotenv`
**Storage**: Supabase (remote); local cache deferred to future features
**Testing**: `flutter_test`, `mocktail`, `bloc_test`
**Target Platform**: iOS, Android (web/desktop deferred)
**Project Type**: Mobile app (Flutter, Clean Architecture)
**Performance Goals**: App startup with all core services initialized < 3 seconds on mid-range device; 60 fps UI
**Constraints**: No PHI in logs; Supabase credentials via environment variables not hardcoded; offline writes deferred to v2
**Scale/Scope**: 23 feature areas across 8 modules; ~50 screens at full build-out; this feature covers the shared `core/` layer only

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Status | Evidence |
|---|-----------|--------|----------|
| I | Clean Architecture | ✅ PASS | All new code lives in `lib/core/` (error, usecase, network, router, di). No domain↔data coupling. UseCase returns `Either<Failure,T>`. |
| II | Type-Safe Functional Error Handling | ✅ PASS | `Failure` subtypes extend `Equatable`. `UseCase` returns `Either`. No raw exceptions cross boundaries. |
| III | Security & HIPAA Compliance | ✅ PASS | Router enforces auth + role guards (defense in depth at UI). Global error handler strips PHI. Supabase credentials loaded from env, never hardcoded. |
| IV | Feature-Modular Organization | ✅ PASS | DI uses GetIt with `initCoreDependencies()` pattern; features call their own `initX()`. Router uses GoRouter with `ShellRoute`. No cross-feature imports. |
| V | Cubit-Default State Management | ✅ PASS | Core foundation uses no Bloc/Cubit itself (infrastructure only). Auth state is a lightweight `ValueNotifier`/`ChangeNotifier` for the router's `refreshListenable`; a full `AuthCubit` is deferred to the auth feature. |
| VI | Supabase-First Backend | ✅ PASS | Supabase client initialized at startup, registered as singleton. No direct API calls from the client outside data sources. |

**Gate result**: PASS — no violations. Proceeding to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-core-foundation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (N/A — no external interfaces in this feature)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── main.dart                              # App entry point (runZonedGuarded, init, runApp)
├── app.dart                               # Root MaterialApp.router widget
├── core/
│   ├── di/
│   │   └── injection_container.dart       # GetIt setup + initCoreDependencies()
│   ├── error/
│   │   ├── exceptions.dart                # ServerException, CacheException, etc.
│   │   └── failures.dart                  # Failure, ServerFailure, CacheFailure, etc.
│   ├── usecase/
│   │   └── usecase.dart                   # UseCase<T, Params> + NoParams
│   ├── network/
│   │   └── network_info.dart              # NetworkInfo interface + implementation
│   ├── router/
│   │   ├── app_router.dart                # GoRouter config, redirect, guards
│   │   └── route_names.dart               # Named route constants
│   ├── utils/
│   │   └── app_logger.dart                # PHI-safe logging utility
│   ├── config/
│   │   └── env_config.dart                # Environment variable access (dotenv)
│   └── theme/                             # (existing — untouched)
│       ├── app_colors.dart
│       ├── app_shadows.dart
│       ├── app_theme.dart
│       ├── app_typography.dart
│       ├── components/
│       └── theme.dart
└── features/                              # (empty — populated by feature modules)

test/
├── core/
│   ├── error/
│   │   └── failures_test.dart
│   ├── usecase/
│   │   └── usecase_test.dart
│   ├── network/
│   │   └── network_info_test.dart
│   └── router/
│       └── app_router_test.dart
└── widget_test.dart                       # (existing)
```

**Structure Decision**: Flutter mobile app structure. All core infrastructure goes under `lib/core/` in dedicated subdirectories. The existing `lib/core/theme/` is preserved as-is. Feature modules will be added under `lib/features/<name>/` by subsequent features.

## Complexity Tracking

> No constitution violations — table not applicable.
