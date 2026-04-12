# Tasks: Core Foundation

**Input**: Design documents from `/specs/001-core-foundation/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Not explicitly requested in the feature specification. Skipped.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/` for source, `test/` for tests at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization — add dependencies and create directory skeleton

- [X] T001 Add required dependencies (`go_router`, `get_it`, `dartz`, `equatable`, `supabase_flutter`, `flutter_bloc`, `connectivity_plus`, `flutter_dotenv`) and dev dependencies (`mocktail`, `bloc_test`) to `pubspec.yaml` and run `flutter pub get`
- [X] T002 [P] Create `.env.example` at project root with placeholder `SUPABASE_URL` and `SUPABASE_ANON_KEY` values and add `.env` to `.gitignore`
- [X] T003 [P] Create directory skeleton under `lib/core/` for `di/`, `error/`, `usecase/`, `network/`, `router/`, `utils/`, `config/` and create empty `lib/features/` directory

**Checkpoint**: Project compiles, all packages resolved, folder structure ready.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core primitives that MUST be complete before ANY user story can be implemented. These are shared by multiple stories.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 [P] Create `Failure` abstract base class extending `Equatable` and concrete subtypes (`ServerFailure`, `CacheFailure`, `NetworkFailure`, `AuthFailure`) in `lib/core/error/failures.dart`
- [X] T005 [P] Create exception types (`ServerException`, `CacheException`, `NetworkException`, `AuthException`) in `lib/core/error/exceptions.dart`
- [X] T006 [P] Create abstract `UseCase<T, Params>` class with `Future<Either<Failure, Type>> call(Params params)` contract and `NoParams` sentinel class in `lib/core/usecase/usecase.dart`
- [X] T007 [P] Create `AppLogger` utility with static `error()`, `warning()`, `info()`, `debug()` methods (PHI-safe, uses `dart:developer` in debug, no-ops in release) in `lib/core/utils/app_logger.dart`
- [X] T008 [P] Create `EnvConfig` class that reads and validates `SUPABASE_URL` and `SUPABASE_ANON_KEY` from `dotenv.env` with startup assertions in `lib/core/config/env_config.dart`

**Checkpoint**: Foundation ready — all shared primitives exist. User story implementation can now begin.

---

## Phase 3: User Story 4 — Standardized Error Types (Priority: P2) 🎯 MVP Foundation

**Goal**: Provide the base error-handling vocabulary used by every future feature's repositories and use cases.

**Independent Test**: Import `failures.dart` and `usecase.dart` from a new file; create a mock use case returning `Left(ServerFailure(...))` and verify pattern matching works without raw exceptions.

> Note: US4 is prioritized before US1-3 in task order because the error types and UseCase are prerequisites for the other stories. The priority label P2 refers to user-facing value, not implementation order.

### Implementation

- [X] T009 [US4] Verify `Failure` subtypes support Equatable equality (two `ServerFailure` instances with same message are `==`) — add equality assertions to `lib/core/error/failures.dart` if needed
- [X] T010 [US4] Verify `NoParams` extends `Equatable` with empty props list in `lib/core/usecase/usecase.dart`

**Checkpoint**: Error types and UseCase contract are complete and independently compilable.

---

## Phase 4: User Story 5 — Supabase Client Initialized and Accessible (Priority: P2)

**Goal**: Supabase client is initialized from `.env` credentials and ready for DI registration.

**Independent Test**: Call `EnvConfig.supabaseUrl` and `EnvConfig.supabaseAnonKey` after `dotenv.load()` and confirm non-empty strings are returned. Initialize `Supabase.initialize()` and confirm the client instance is non-null.

### Implementation

- [X] T011 [US5] Wire Supabase initialization sequence: call `dotenv.load()` then `Supabase.initialize(url: EnvConfig.supabaseUrl, anonKey: EnvConfig.supabaseAnonKey)` in the startup path (to be called from `main.dart` in Phase 6). Create an `initSupabase()` async helper in `lib/core/config/env_config.dart`

**Checkpoint**: Supabase client can be initialized given valid credentials.

---

## Phase 5: User Story 6 — Network Connectivity Awareness (Priority: P3)

**Goal**: A `NetworkInfo` interface and implementation are available for repositories to check online/offline status before making remote calls.

**Independent Test**: Instantiate `NetworkInfoImpl` with a mock `Connectivity` instance. Verify `isConnected` returns `true` when connectivity result is WiFi and `false` when `ConnectivityResult.none`.

### Implementation

- [X] T012 [US6] Create `NetworkInfo` abstract class (with `Future<bool> get isConnected` and `Stream<bool> get connectivityStream`) and `NetworkInfoImpl` wrapping `connectivity_plus` in `lib/core/network/network_info.dart`

**Checkpoint**: NetworkInfo is complete and independently testable.

---

## Phase 6: User Story 2 — DI Container Available App-Wide (Priority: P1)

**Goal**: GetIt container is configured with all core dependencies and provides a pattern for features to register their own.

**Independent Test**: Call `initCoreDependencies()`, then resolve `NetworkInfo`, `SupabaseClient`, and `AuthStateNotifier` from the container — all return valid instances.

> Note: US2 appears after US4-6 because the DI container registers the services created in those stories.

### Implementation

- [X] T013 [US2] Create `injection_container.dart` in `lib/core/di/` with `GetIt.instance` aliased as `sl`, an async `initCoreDependencies()` function that registers: `Connectivity` (singleton), `NetworkInfo` as `NetworkInfoImpl` (lazy singleton), `SupabaseClient` from `Supabase.instance.client` (singleton), `AuthStateNotifier` (lazy singleton)
- [X] T014 [US2] Add doc comment in `injection_container.dart` showing the per-feature `initX()` pattern for future feature modules

**Checkpoint**: DI container is initialized and all core services are resolvable.

---

## Phase 7: User Story 3 — Router Enforces Auth and Role Guards (Priority: P1)

**Goal**: GoRouter is configured with auth/role redirect guards and nested `StatefulShellRoute` for the dashboard, preventing unauthorized access at the navigation level.

**Independent Test**: Set `AuthStateNotifier` to `unauthenticated` and navigate to `/home` — verify redirect to `/login`. Set to `authenticated` with role `doctor` — verify `/home` renders. Navigate to an admin-only route — verify redirect to `/access-denied`.

### Implementation

- [X] T015 [P] [US3] Create `AuthStatus` enum (`unknown`, `authenticated`, `unauthenticated`) and `UserRole` enum (7 roles per data-model.md) in `lib/core/router/auth_state.dart`
- [X] T016 [P] [US3] Create `AuthStateNotifier` extending `ChangeNotifier` with `AuthStatus status`, `UserRole? role`, and `void setAuth(AuthStatus, UserRole?)` method in `lib/core/router/auth_state.dart`
- [X] T017 [P] [US3] Create named route constants (`RouteNames.login`, `RouteNames.accessDenied`, `RouteNames.dashboard`, `RouteNames.home`) in `lib/core/router/route_names.dart`
- [X] T018 [US3] Create `AppRouter` class in `lib/core/router/app_router.dart` with a `GoRouter` getter that configures: redirect callback checking `AuthStateNotifier` status and role, `refreshListenable` wired to `AuthStateNotifier`, top-level routes for `/login` and `/access-denied` (placeholder pages), `StatefulShellRoute.indexedStack` for dashboard with a `ScaffoldWithNavBar` shell widget, and a `/home` branch as the first tab (placeholder page)
- [X] T019 [US3] Create `ScaffoldWithNavBar` shell widget (placeholder `Scaffold` with a `NavigationBar` or `BottomNavigationBar`) in `lib/core/router/scaffold_with_nav_bar.dart`
- [X] T020 [US3] Create placeholder page widgets (`LoginPlaceholderPage`, `AccessDeniedPage`, `HomePlaceholderPage`) in `lib/core/router/placeholder_pages.dart`
- [X] T021 [US3] Register `AppRouter` (and its `GoRouter`) in the DI container in `lib/core/di/injection_container.dart` — depends on `AuthStateNotifier`

**Checkpoint**: Router is fully functional with auth/role protection. Unauthenticated users see login; role mismatches redirect to access-denied.

---

## Phase 8: User Story 1 — App Launches Safely with Global Error Handling (Priority: P1) 🎯 MVP

**Goal**: The app entry point wraps everything in `runZonedGuarded`, sets `FlutterError.onError`, initializes all services, and starts the router-driven `MaterialApp`.

**Independent Test**: Launch the app — verify it reaches the initial screen. Throw an intentional error — verify it's caught by the global handler and logged without crashing.

### Implementation

- [X] T022 [US1] Create `App` widget in `lib/app.dart` — a `StatelessWidget` returning `MaterialApp.router` configured with `routerConfig` from `AppRouter` resolved via GetIt, the existing `AppTheme.light`, and `debugShowCheckedModeBanner: false`
- [X] T023 [US1] Rewrite `lib/main.dart`: call `WidgetsFlutterBinding.ensureInitialized()`, `await dotenv.load()`, `await Supabase.initialize(...)`, `await initCoreDependencies()`, set `FlutterError.onError` to route to `AppLogger.error()`, wrap `runApp(const App())` inside `runZonedGuarded` with zone error callback routing to `AppLogger.error()`
- [X] T024 [US1] Remove the old `MyApp`, `MyHomePage`, and `_MyHomePageState` classes from `lib/main.dart` (replaced by `lib/app.dart` and router-managed pages)

**Checkpoint**: App launches, all core services initialize, global error handling is active. This is the full MVP — the app boots with auth-guarded routing and DI.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final integration verification and cleanup.

- [X] T025 Verify end-to-end startup: `flutter run` launches successfully with a valid `.env`, displays login placeholder (since `AuthStateNotifier` defaults to `unauthenticated`)
- [X] T026 Verify error handling: temporarily insert `throw Exception('test')` in a widget build method, confirm it's caught by `FlutterError.onError` and logged via `AppLogger`, then remove the test throw
- [X] T027 Add `assets` entry for `.env` in `pubspec.yaml` under `flutter:` section (required by `flutter_dotenv` to load the file at runtime)

---

## Dependencies

```text
Phase 1 (Setup)
  └─▶ Phase 2 (Foundational: error types, usecase, logger, env config)
        ├─▶ Phase 3 (US4: verify error types) ──┐
        ├─▶ Phase 4 (US5: Supabase init)  ──────┤
        └─▶ Phase 5 (US6: NetworkInfo)  ─────────┤
                                                  ▼
                                    Phase 6 (US2: DI container)
                                            │
                                            ▼
                                    Phase 7 (US3: Router)
                                            │
                                            ▼
                                    Phase 8 (US1: main.dart / App)
                                            │
                                            ▼
                                    Phase 9 (Polish)
```

## Parallel Execution Opportunities

| Tasks | Why Parallelizable |
|-------|--------------------|
| T002, T003 | Different files, no shared state |
| T004, T005, T006, T007, T008 | Each creates an independent file in a different `core/` subdirectory |
| T015, T016, T017 | T015-T016 share a file but T017 is a separate file; T015+T016 can be done together, T017 in parallel |
| Phases 3, 4, 5 | US4, US5, US6 depend only on Phase 2 — can run simultaneously |

## Implementation Strategy

- **MVP scope**: Complete through Phase 8 — the app boots with auth-guarded routing, DI, global error handling, and Supabase connectivity.
- **Incremental delivery**: Each phase produces compilable code. After Phase 2, individual user stories can technically be delivered independently.
- **Suggested first milestone**: Phases 1–8 as a single PR on `001-core-foundation` branch.
