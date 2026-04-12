# Data Model: Core Foundation

**Feature**: 001-core-foundation
**Date**: 2026-04-07

> This feature establishes core infrastructure, not domain entities. The "entities" below are architectural primitives that all future features depend on.

---

## Failure (abstract base)

Represents a handled error that has crossed an architectural boundary.

| Field | Type | Description |
|-------|------|-------------|
| `message` | `String` | User-facing error message (PHI-free) |

**Subtypes**:

| Subtype | Origin | When Used |
|---------|--------|-----------|
| `ServerFailure` | Remote data source | Supabase API errors, HTTP failures, timeout |
| `CacheFailure` | Local data source | Read/write errors from local storage |
| `NetworkFailure` | Network layer | Device is offline (no connectivity) |
| `AuthFailure` | Auth layer | Unauthenticated, token expired, role mismatch |

**Rules**:
- All subtypes extend `Equatable` via the base `Failure` class.
- Two failures with the same type and message are equal.
- Failure messages MUST NOT contain PHI (patient names, IDs, medical data).

---

## Exception Types

Raw exceptions caught at the data layer boundary before being mapped to `Failure`.

| Exception | Thrown By | Mapped To |
|-----------|----------|-----------|
| `ServerException` | Remote data sources on non-2xx responses | `ServerFailure` |
| `CacheException` | Local data sources on read/write errors | `CacheFailure` |
| `NetworkException` | Repositories when device is offline | `NetworkFailure` |
| `AuthException` | Auth data sources on auth failures | `AuthFailure` |

Each exception carries a `message` string for debugging (logged via `AppLogger`).

---

## AuthStatus (enum)

Represents the current authentication state for routing decisions.

| Value | Description |
|-------|-------------|
| `unknown` | App just launched, auth state not yet determined |
| `authenticated` | User is logged in with a valid session |
| `unauthenticated` | User is not logged in or session expired |

---

## UserRole (enum)

Represents the user's role within the clinic system. Used by the router for role-based guard decisions.

| Value | DB Equivalent | Description |
|-------|---------------|-------------|
| `superAdmin` | `super_admin` | Full system access across all clinics |
| `clinicAdmin` | `clinic_admin` | Full access within their clinic |
| `doctor` | `doctor` | Clinical access: patients, EHR, prescriptions, schedule |
| `nurse` | `nurse` | Clinical support: triage, vitals, queue |
| `receptionist` | `receptionist` | Front desk: appointments, check-in, billing |
| `pharmacist` | `pharmacist` | Inventory and dispensing |
| `patient` | `patient` | Patient portal: own records, appointments, chat |

---

## AuthState (value object)

Held by `AuthStateNotifier` to represent the current user session for routing.

| Field | Type | Description |
|-------|------|-------------|
| `status` | `AuthStatus` | Current authentication status |
| `role` | `UserRole?` | User's role (null when unauthenticated or unknown) |

**State Transitions**:

```
unknown ──(session check succeeds)──▶ authenticated (role populated)
unknown ──(no session / expired)────▶ unauthenticated
authenticated ──(logout / token expiry)──▶ unauthenticated
unauthenticated ──(login succeeds)──▶ authenticated (role populated)
```

---

## UseCase<Type, Params> (abstract)

Represents a single unit of business logic.

| Type Parameter | Description |
|----------------|-------------|
| `Type` | The success return type |
| `Params` | The parameter type (use `NoParams` if none needed) |

**Contract**: `Future<Either<Failure, Type>> call(Params params)`

**NoParams**: A sentinel class used when a use case requires no input. Extends `Equatable` with empty props.

---

## NetworkInfo (abstract interface)

| Member | Type | Description |
|--------|------|-------------|
| `isConnected` | `Future<bool>` | One-shot connectivity check |
| `connectivityStream` | `Stream<bool>` | Continuous connectivity status changes |

**Implementation**: `NetworkInfoImpl` wraps `connectivity_plus`'s `Connectivity` class. Maps `ConnectivityResult.none` → `false`, all others → `true`.

---

## Route Structure

| Route Path | Name | Auth Required | Roles | Description |
|------------|------|---------------|-------|-------------|
| `/login` | `login` | No | — | Login screen (placeholder) |
| `/access-denied` | `accessDenied` | No | — | Shown when role check fails |
| `/` | `dashboard` | Yes | All | Dashboard shell with bottom nav |
| `/home` | `home` | Yes | All | Home tab (placeholder child of dashboard) |

**Guard Logic** (in `redirect`):

1. If `status == unknown` → return `/` (splash/loading — could be expanded)
2. If `status == unauthenticated` AND route is not `/login` → return `/login`
3. If `status == authenticated` AND route is `/login` → return `/`
4. If route requires specific roles AND `user.role` not in allowed set → return `/access-denied`
5. Otherwise → return `null` (allow navigation)

---

## Relationships

```text
main.dart
  └─▶ initCoreDependencies() [injection_container.dart]
        ├─▶ EnvConfig (reads .env via flutter_dotenv)
        ├─▶ SupabaseClient (initialized with EnvConfig values)
        ├─▶ Connectivity (connectivity_plus)
        ├─▶ NetworkInfoImpl(Connectivity) → registered as NetworkInfo
        ├─▶ AuthStateNotifier (ChangeNotifier)
        └─▶ GoRouter(AuthStateNotifier) → registered as AppRouter

  └─▶ runZonedGuarded
        └─▶ FlutterError.onError = AppLogger.error
        └─▶ runApp(App)
              └─▶ App reads GoRouter from GetIt
                    └─▶ MaterialApp.router(routerConfig: router)
```
