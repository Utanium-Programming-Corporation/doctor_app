# Feature Specification: Core Foundation

**Feature Branch**: `001-core-foundation`  
**Created**: 2026-04-07  
**Status**: Draft  
**Input**: User description: "Core Foundation — set up the Flutter app's core layer including: GoRouter configuration with auth/role guards, GetIt dependency injection container, global error handling (runZonedGuarded + FlutterError.onError), base Failure/Exception classes with Either (Dartz), base UseCase abstract class, Supabase client initialization, network info utility, and the app entry point (main.dart) wired together."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - App Launches Safely with Global Error Handling (Priority: P1)

As a developer, I need the app to start within a guarded execution zone so that any uncaught errors are captured, logged, and presented gracefully instead of crashing silently or showing raw stack traces to end users.

**Why this priority**: Without a safe startup harness nothing else works. Every future feature depends on the app booting reliably and errors being caught at the outermost boundary.

**Independent Test**: Launch the app; verify it reaches the home screen. Throw an intentional error in a widget and confirm it is caught by the global handler instead of crashing the app.

**Acceptance Scenarios**:

1. **Given** the app is freshly installed, **When** the user opens the app for the first time, **Then** the app starts, initializes all required services, and displays the initial screen within 3 seconds on a mid-range device.
2. **Given** the app is running, **When** an unhandled exception occurs in any widget, **Then** the error is caught by the global error handler, a user-friendly fallback is shown, and the error details are logged (without PHI).
3. **Given** the app is running, **When** an asynchronous error occurs outside the widget tree (e.g. in a stream or future), **Then** the zoned error handler captures it, logs it, and the app remains functional.

---

### User Story 2 - Dependency Injection Container Is Available App-Wide (Priority: P1)

As a developer building features, I need a single service locator that is initialized before the first frame renders, so that every feature module can register and retrieve its dependencies without manual wiring.

**Why this priority**: Dependency injection is the backbone of Clean Architecture. No feature cubit, use case, or repository can be instantiated without the DI container being ready first.

**Independent Test**: After app startup, request a registered singleton from the container and confirm it returns the expected instance.

**Acceptance Scenarios**:

1. **Given** the app is starting, **When** the DI container initialization runs, **Then** all core-level services (Supabase client wrapper, network info utility) are registered and retrievable.
2. **Given** a feature module has registered its dependencies via its own init function, **When** a cubit requests a use case from the container, **Then** it receives a fully constructed instance with all transitive dependencies resolved.
3. **Given** a dependency is not registered, **When** it is requested from the container, **Then** a clear, descriptive error is raised at development time (fail-fast) rather than a null or cryptic message.

---

### User Story 3 - Router Enforces Authentication and Role Guards (Priority: P1)

As a user of the clinic system, I must only be able to access screens that match my authentication state and role, so that unauthorized access is prevented at the navigation level.

**Why this priority**: Auth and role routing is the first line of defense for HIPAA-style compliance. Every screen in every future feature depends on the router knowing whether the user is logged in and what role they hold.

**Independent Test**: Simulate an unauthenticated user navigating to a protected route and confirm they are redirected to the login screen. Simulate a logged-in user with role "receptionist" navigating to an admin-only route and confirm they are redirected to an unauthorized screen.

**Acceptance Scenarios**:

1. **Given** a user is not authenticated, **When** they attempt to navigate to any protected route, **Then** they are redirected to the login screen.
2. **Given** a user is authenticated with role "doctor", **When** they navigate to a route their role is permitted to access, **Then** the route renders normally.
3. **Given** a user is authenticated with role "doctor", **When** they attempt to navigate to an admin-only route, **Then** they are redirected to an "access denied" screen or the dashboard.
4. **Given** a user logs out, **When** the auth state changes, **Then** the router immediately redirects them to the login screen regardless of current location.

---

### User Story 4 - Standardized Error Types for All Features (Priority: P2)

As a developer, I need a common set of failure and exception types that every feature can use to represent errors consistently, so that error handling is uniform across the entire codebase and no raw exceptions leak across architectural layers.

**Why this priority**: Builds on top of the running app (P1) and is required before any feature can implement use cases that return `Either<Failure, T>`.

**Independent Test**: Create a use case that returns a `ServerFailure` and verify the calling code can pattern-match on it without catching raw exceptions.

**Acceptance Scenarios**:

1. **Given** a data source throws a network-related exception, **When** the repository catches it, **Then** it maps it to a typed `ServerFailure` with a user-facing message.
2. **Given** a data source throws a cache-related exception, **When** the repository catches it, **Then** it maps it to a typed `CacheFailure`.
3. **Given** two failures of the same type and same properties, **When** they are compared, **Then** they are equal (Equatable).

---

### User Story 5 - Supabase Client Is Initialized and Accessible (Priority: P2)

As a developer, I need the Supabase client to be initialized once during app startup and made available through the DI container, so that every data source across all features can access the database, auth, storage, and real-time services through a single managed instance.

**Why this priority**: Every data-layer class in every future feature depends on the Supabase client. It must be set up correctly once with proper configuration.

**Independent Test**: After startup, retrieve the Supabase client from the DI container and verify it is initialized (not null) and configured with the correct project URL.

**Acceptance Scenarios**:

1. **Given** the app is starting, **When** the Supabase initialization completes, **Then** the Supabase client instance is registered in the DI container.
2. **Given** the Supabase project URL or anon key is missing or invalid, **When** initialization is attempted, **Then** the app reports a clear startup error rather than silently failing.
3. **Given** the Supabase client is initialized, **When** any data source retrieves it, **Then** it receives the same singleton instance.

---

### User Story 6 - Network Connectivity Awareness (Priority: P3)

As a user on a mobile device, I need the app to be aware of network connectivity status so that it can inform me when I am offline and degrade gracefully instead of showing cryptic network errors.

**Why this priority**: Useful but not blocking for initial development. Features can initially assume online connectivity and add offline handling later. The network info utility provides the foundation.

**Independent Test**: Toggle airplane mode on a device; verify the network info utility correctly reports offline status.

**Acceptance Scenarios**:

1. **Given** the device has internet connectivity, **When** the network info utility is queried, **Then** it reports the device as online.
2. **Given** the device loses connectivity, **When** the network info utility is queried, **Then** it reports the device as offline.
3. **Given** the device is offline, **When** a repository checks connectivity before making a remote call, **Then** it can return a `NetworkFailure` without attempting the request.

### Edge Cases

- What happens when the Supabase initialization fails (e.g. invalid URL/key, network timeout at startup)? The app must show a clear startup error screen rather than a blank screen or crash.
- What happens when the DI container is queried for a dependency before initialization completes? The app must fail fast with a descriptive error during development.
- What happens when the device connectivity toggles rapidly (flapping)? The network utility must debounce or coalesce status changes to avoid cascading rebuilds.
- What happens when the router receives a deep link while the user is unauthenticated? The deep link target must be preserved and the user redirected to login; after successful login, they should be navigated to the original deep-link destination.
- What happens when multiple features register dependencies with conflicting names? The DI container must detect duplicates at registration time and throw descriptive errors.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app entry point MUST wrap the entire application in `runZonedGuarded` to capture all uncaught asynchronous errors.
- **FR-002**: The app MUST set `FlutterError.onError` to a custom handler that logs framework errors and prevents raw error screens from appearing in release mode.
- **FR-003**: The DI container MUST be fully initialized before the first frame renders (before `runApp` is called inside the guarded zone).
- **FR-004**: The DI container MUST support per-feature registration functions that can be called from a central initialization point.
- **FR-005**: The router MUST define a redirect callback that checks authentication state and user role before allowing navigation to any protected route.
- **FR-006**: The router MUST support nested shell routes for the main dashboard layout that persists across child route changes.
- **FR-007**: The system MUST provide a base `Failure` type with concrete subtypes (`ServerFailure`, `CacheFailure`, `NetworkFailure`, `AuthFailure`) that extend Equatable.
- **FR-008**: The system MUST provide a base `UseCase` abstract class that accepts parameters and returns `Either<Failure, T>`.
- **FR-009**: The system MUST provide a `NoParams` type for use cases that require no input.
- **FR-010**: The Supabase client MUST be initialized during app startup with project URL and anon key sourced from environment configuration (not hardcoded).
- **FR-011**: The Supabase client MUST be registered as a singleton in the DI container.
- **FR-012**: A network info utility MUST be available to check current connectivity status synchronously or via a stream.
- **FR-013**: The network info utility MUST be registered in the DI container.
- **FR-014**: Global error logging MUST NOT include Protected Health Information (PHI) in any log output.
- **FR-015**: The router MUST expose named route constants so features reference routes by name rather than hardcoded path strings.

### Key Entities

- **Failure**: Represents a handled error that has crossed an architectural boundary. Subtypes distinguish the error origin (server, cache, network, auth). Each carries a user-facing message.
- **UseCase**: Represents a single unit of business logic. Accepts typed parameters and returns a typed `Either<Failure, SuccessType>`.
- **AppRouter**: Encapsulates all route definitions, redirect logic, auth guards, and role guards. Consumed by the app's top-level widget.
- **NetworkInfo**: Provides current connectivity status (online/offline) and optionally a stream of changes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The app launches to the initial screen within 3 seconds on a mid-range device, with all core services initialized.
- **SC-002**: 100% of uncaught exceptions (both synchronous widget errors and asynchronous zone errors) are captured by the global handler without crashing the app.
- **SC-003**: Unauthenticated users are redirected to login within one navigation frame — no protected content flashes on screen.
- **SC-004**: Every core dependency (Supabase client, network info, router) is resolvable from the DI container after initialization, verified by automated tests.
- **SC-005**: A new feature module can register its own dependencies and routes by following the established pattern, with no changes to existing core files beyond adding an import and a single init call.
- **SC-006**: All failure types correctly implement equality — two failures with the same type and message are equal.

## Assumptions

- Supabase project credentials (URL and anon key) will be provided via a `.env` file or compile-time environment variables — the exact mechanism will be decided during planning.
- The auth state will initially be represented as a simple authenticated/unauthenticated enum with a role field; a full `AuthCubit` with login/logout flows is out of scope for this foundational feature and will be built in a dedicated auth feature.
- The existing theme setup in `lib/core/theme/` will remain untouched; this feature only adds new files alongside it.
- Offline cache storage (Hive/Isar) is out of scope for this core foundation; it will be introduced in the feature that first requires it.
- The initial route set will include placeholder routes (login, dashboard shell, access-denied) with minimal UI — full screen implementations are deferred to their respective features.
- Arabic/English localization infrastructure (easy_localization) is out of scope here; the core foundation provides the structural skeleton only.
