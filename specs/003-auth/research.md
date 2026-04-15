# Research: Authentication & User Onboarding (003-auth)

**Date**: 2026-04-12  
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## R1: Supabase Auth with Native Google/Apple Sign-In

**Decision**: Use `google_sign_in` and `sign_in_with_apple` native SDKs to obtain ID tokens, then pass them to `supabase_flutter` via `signInWithIdToken()`.

**Rationale**: Native SDKs provide the best UX on mobile (system-level account picker for Google, Face ID/Touch ID for Apple). Supabase's `signInWithIdToken()` accepts the ID token and creates/updates the auth.users row server-side without requiring a browser redirect.

**Alternatives considered**:
- Supabase OAuth redirect flow (`signInWithOAuth()`): Opens a web browser. Poor UX on mobile. Reserved for web fallback only.
- Firebase Auth: Adds a separate auth dependency. Constitution mandates Supabase-first.

**Implementation pattern**:
```dart
// Google
final googleUser = await GoogleSignIn().signIn();
final idToken = (await googleUser?.authentication)?.idToken;
await supabase.auth.signInWithIdToken(
  provider: OAuthProvider.google,
  idToken: idToken!,
);

// Apple
final credential = await SignInWithApple.getAppleIDCredential(scopes: []);
await supabase.auth.signInWithIdToken(
  provider: OAuthProvider.apple,
  idToken: credential.identityToken!,
);
```

## R2: AuthCubit Replacing AuthStateNotifier

**Decision**: Replace the existing `AuthStateNotifier` (ChangeNotifier) with `AuthCubit` (flutter_bloc). The cubit becomes the single source of auth truth, and GoRouter's `refreshListenable` binds to a `Stream`-to-`ChangeNotifier` bridge.

**Rationale**: Constitution V mandates Cubit-default state management. The existing `AuthStateNotifier` is a plain ChangeNotifier with no business logic — it's just a state holder. AuthCubit adds proper state management with loading states, error handling, and profile-awareness.

**Alternatives considered**:
- Keep AuthStateNotifier and add AuthCubit alongside: Creates two sources of truth. Rejected.
- Make AuthCubit extend ChangeNotifier: Bloc library cubits don't extend ChangeNotifier. Can't use directly as `refreshListenable`.

**Bridge pattern for GoRouter**:
```dart
class AuthCubitRefreshListenable extends ChangeNotifier {
  late final StreamSubscription _sub;
  AuthCubitRefreshListenable(AuthCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
```

**Auth states**:
- `AuthInitial` — app just launched, checking session
- `AuthLoading` — sign-in/sign-out in progress  
- `Authenticated(User user, UserProfile? profile)` — signed in. `profile == null` means needs onboarding.
- `Unauthenticated` — no valid session
- `AuthError(String message)` — transient error (reverts to Unauthenticated after display)

**Router redirect logic** (replaces existing `_redirect`):
- `AuthInitial` / `AuthLoading` → stay on current route (show splash)
- `Unauthenticated` / `AuthError` → redirect to `/welcome`
- `Authenticated(profile: null)` → redirect to `/profile-setup`
- `Authenticated(profile: notNull)` → redirect to `/home`

## R3: Profiles Table & RLS

**Decision**: Create a `profiles` table with `id` as a FK to `auth.users.id`, with RLS policies scoped to the user's own row.

**Rationale**: The spec requires profile data separate from auth.users (full_name, phone, role, language, avatar). RLS ensures users can only read/update their own profile. Constitution III mandates RLS on every table.

**Note on clinic_id**: The spec explicitly states `clinic_id` is out of scope for this feature. The profiles table will NOT include `clinic_id` now. It will be added by a future clinic-management feature. The RLS policy is simpler: `auth.uid() = id`.

**Alternatives considered**:
- Store profile data in auth.users.raw_user_meta_data: Limited to JSON blob. Can't enforce types or RLS granularity. Rejected.
- Use a Postgres function for profile creation: Over-engineering for a simple insert. Rejected for now.

## R4: AppFormField & AppValidators (Prerequisites)

**Decision**: Create `AppFormField` widget and `AppValidators` utility in `lib/core/` before building the ProfileSetupPage.

**Rationale**: Constitution VIII mandates all text fields use `AppFormField` via `buildTextField`/`buildTextFieldClearable` helpers, and all validation use `AppValidators`. These don't exist yet in the codebase.

**AppFormField design**:
- A wrapper around `TextFormField` that applies the app's `InputDecoration` theme consistently.
- Static helpers: `buildTextField(label, controller, validator, ...)` and `buildTextFieldClearable(label, controller, validator, onClear, ...)`.
- Keeps page code minimal (one function call per field).

**AppValidators design**:
- Composable pattern: each validator is a `String? Function(String?)` that returns null on success or error message on failure.
- Composition: `AppValidators.compose([AppValidators.required(), AppValidators.minLength(2)])`.
- Common validators: `required()`, `minLength(n)`, `maxLength(n)`, `phone()`, `email()`.

## R5: Dependency Registration Order in initAuth()

**Decision**: Register in bottom-up dependency order: data sources → repositories → use cases → cubits.

**Registration order**:
```
1. AuthRemoteDataSource (depends on: SupabaseClient)
2. AuthRepository (depends on: AuthRemoteDataSource, NetworkInfo)
3. SignInWithGoogle (depends on: AuthRepository)
4. SignInWithApple (depends on: AuthRepository)
5. SignOut (depends on: AuthRepository)
6. GetCurrentUser (depends on: AuthRepository)
7. GetUserProfile (depends on: AuthRepository)
8. CreateUserProfile (depends on: AuthRepository)
9. WatchAuthState (depends on: AuthRepository)
10. AuthCubit (depends on: all use cases above) — registerLazySingleton (global singleton)
11. AuthCubitRefreshListenable (depends on: AuthCubit) — registerLazySingleton
```

**Changes to injection_container.dart**:
- Remove `AuthStateNotifier` registration.
- `AppRouter` now depends on `AuthCubitRefreshListenable` + `AuthCubit` instead of `AuthStateNotifier`.
- Call `initAuth()` from `initCoreDependencies()` BEFORE `AppRouter` registration.

## R6: WatchAuthState Stream and Cubit Lifecycle

**Decision**: AuthCubit subscribes to `supabase.auth.onAuthStateChange` via the `WatchAuthState` use case on construction. When an auth event fires, the cubit fetches the profile and emits the appropriate state.

**Rationale**: Constitution V says Cubit is default; Bloc is only for "complex event streams." The auth state stream is simple (one event type: auth state change). The cubit subscribes internally and updates state — no Bloc event mapping needed.

**Cubit lifecycle**:
1. On construction: call `WatchAuthState()` to get the stream. Subscribe.
2. On `AuthChangeEvent.signedIn` / `AuthChangeEvent.tokenRefreshed`: fetch profile → emit `Authenticated(user, profile)`.
3. On `AuthChangeEvent.signedOut` / null session: emit `Unauthenticated`.
4. `signInWithGoogle()` / `signInWithApple()`: emit `AuthLoading`, call use case, let stream handle the result.
5. `signOut()`: emit `AuthLoading`, call use case, let stream handle the result.
6. `createProfile()`: call use case, re-fetch profile, emit updated `Authenticated`.
7. On `close()`: cancel stream subscription.
