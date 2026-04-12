# Research: Core Foundation

**Feature**: 001-core-foundation
**Date**: 2026-04-07

## R1: Environment Variable Loading for Supabase Credentials

### Decision: `flutter_dotenv`

### Rationale
- Loads `.env` files at runtime, making it simple to swap configurations between dev/staging/production without recompiling.
- Well-established in the Flutter ecosystem (1000+ pub likes).
- The `.env` file is `.gitignore`d, preventing credentials from leaking into version control.

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| `--dart-define` (compile-time) | Requires passing env vars in every build command; awkward for CI and team onboarding |
| `envied` (code-generated) | Adds build_runner dependency for a one-file use case; over-engineering for credential loading |
| Hardcoded constants | Violates constitution (III — HIPAA Compliance) and is a security risk |

### Implementation Notes
- Use `dotenv.load()` in `main()` before any other initialization.
- Access via a typed `EnvConfig` class that reads from `dotenv.env` and validates that required keys are present at startup.
- `.env.example` committed to repo with placeholder values for onboarding.

---

## R2: Network Connectivity Package

### Decision: `connectivity_plus`

### Rationale
- First-party Flutter Community package, maintained by the Flutter ecosystem team.
- Provides both a one-shot `checkConnectivity()` and a `onConnectivityChanged` stream.
- Lightweight — only checks the transport layer (WiFi/cellular/none), which is sufficient for v1 where we just need to know "device has a network interface" before making requests.

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| `internet_connection_checker` | Performs actual DNS lookups / HTTP HEAD to verify internet access. More accurate but adds latency to every check and requires network permissions. Overkill for v1 where repositories already handle `ServerFailure` on actual request failure. |
| Manual `dart:io` socket checks | Platform-dependent, no web support, requires more boilerplate |

### Implementation Notes
- `NetworkInfo` abstract class with `isConnected` getter (returns `Future<bool>`) and a `connectivityStream`.
- `NetworkInfoImpl` wraps `Connectivity` from `connectivity_plus`.
- Repositories can optionally check `isConnected` before remote calls to return `NetworkFailure` early, but this is not mandatory — the primary safety net is catching `SocketException` in the data layer.

---

## R3: Router Auth State Mechanism

### Decision: Lightweight `AuthStateNotifier` extending `ChangeNotifier`

### Rationale
- GoRouter's `refreshListenable` accepts any `Listenable`. A `ChangeNotifier` is the simplest implementation that triggers route re-evaluation when auth state changes.
- A full `AuthCubit` (flutter_bloc) is out of scope for this core foundation feature (per spec assumptions). The `AuthStateNotifier` is a thin bridge that the future auth feature will connect to its cubit.
- This avoids pulling `flutter_bloc` into the router's redirect logic, keeping the router dependency-free from state management libraries.

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| `GoRouterRefreshStream` wrapping a `Stream<AuthState>` | Requires a stream source to already exist. Since `AuthCubit` is deferred, there's no stream to wrap yet. |
| Direct `AuthCubit` in redirect | Couples router to `flutter_bloc`; violates separation and makes router testing harder. |
| No `refreshListenable` (manual push) | Router wouldn't automatically react to auth changes; requires explicit `context.go('/login')` calls scattered through logoutlogic — fragile. |

### Implementation Notes
- `AuthStateNotifier` holds a simple enum `AuthStatus { unknown, authenticated, unauthenticated }` and a `UserRole?`.
- Registered in GetIt as a lazy singleton. Router reads it in `redirect`.
- The auth feature will inject actual auth state into this notifier via its cubit.

### Auth Roles (from plan.md / constitution)
```dart
enum UserRole {
  superAdmin,
  clinicAdmin,
  doctor,
  nurse,
  receptionist,
  pharmacist,
  patient,
}
```

---

## R4: Error Logging Strategy

### Decision: Custom `AppLogger` utility (thin wrapper around `dart:developer` + `debugPrint`)

### Rationale
- The global error handler needs a logger that is guaranteed to never include PHI (constitutional requirement III).
- A custom wrapper lets us enforce sanitization rules at the logging boundary.
- In development, logs go to `dart:developer` `log()` (visible in DevTools). In release, they are silently dropped or sent to a future crash reporting service (Sentry/Crashlytics — deferred).
- Adding a full logging package (`logger`, `talker`) introduces UI overlays and formatting that isn't needed yet and adds dependency weight.

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| `logger` package | Pretty-prints to console with borders and colors. Nice for dev, but we need a programmatic interface for future crash reporting integration, not a pretty-printer. |
| `talker` package | Feature-rich (HTTP logs, BLoC logs, UI overlay). Useful later but over-engineered for the core foundation. Can be added as a dev tool in a future feature. |
| No logging (just `print`) | Unstructured, impossible to filter, and `print` doesn't show in `dart:developer` log viewer. |

### Implementation Notes
- `AppLogger` with static methods: `AppLogger.error()`, `AppLogger.warning()`, `AppLogger.info()`, `AppLogger.debug()`.
- Each method accepts a `message`, optional `error`, and optional `StackTrace`.
- In `kReleaseMode`, only `error` and `warning` are active; `info` and `debug` are no-ops.
- The global error handler (`runZonedGuarded` callback and `FlutterError.onError`) routes through `AppLogger.error()`.

---

## R5: GoRouter Shell Route Pattern for Dashboard

### Decision: Single `ShellRoute` with `StatefulShellRoute.indexedStack`

### Rationale
- The clinic app's dashboard needs a persistent bottom navigation / side rail that stays visible while child routes change (schedule, queue, chat, etc.).
- `StatefulShellRoute.indexedStack` preserves the state of each tab's navigation stack, so switching tabs doesn't lose scroll position or form state.
- This is the GoRouter-recommended pattern for persistent navigation shells.

### Alternatives Considered

| Alternative | Rejected Because |
|-------------|-----------------|
| Plain `ShellRoute` (non-stateful) | Rebuilds child on every tab switch — loses state, bad UX for form-heavy healthcare screens. |
| Manual `IndexedStack` outside router | Decouples navigation from GoRouter's URL system; deep links won't work correctly; breaks back button. |
| `Navigator 2.0` directly | GoRouter already provides the declarative API. Going lower-level adds boilerplate with no benefit. |

### Implementation Notes
- Define a `ScaffoldWithNavBar` shell that provides the bottom nav / side rail.
- Each tab is a `StatefulShellBranch` with its own navigator and route tree.
- Protected routes are children of the shell route; unprotected routes (login, onboarding) are siblings at the top level.
- The `redirect` callback runs before shell resolution, so auth checks happen first.

---

## R6: Dependency Registration Pattern

### Decision: Central `injection_container.dart` calling typed `initX()` functions

### Rationale
- Constitution IV mandates per-feature `initX()` registration functions.
- A single `initCoreDependencies()` registers core services (Supabase, NetworkInfo, Router).
- Each future feature adds its own `initScheduling()`, `initQueue()`, etc.
- Registration order matters only for eager singletons; all feature registrations use `registerLazySingleton` or `registerFactory` to avoid order-of-initialization bugs.

### Implementation Notes
- `GetIt.instance` aliased as `sl` (service locator) for brevity — standard convention.
- Core registrations:
  1. `EnvConfig` (sync — already loaded by `dotenv.load()`)
  2. `SupabaseClient` (singleton — already initialized by `Supabase.initialize()`)
  3. `Connectivity` from `connectivity_plus` (singleton)
  4. `NetworkInfo` (`NetworkInfoImpl` depending on `Connectivity`)
  5. `AuthStateNotifier` (lazy singleton)
  6. `GoRouter` (lazy singleton, depends on `AuthStateNotifier`)
