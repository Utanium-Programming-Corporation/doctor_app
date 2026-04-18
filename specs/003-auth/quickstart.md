# Quickstart: Authentication & User Onboarding (003-auth)

**Date**: 2026-04-12  
**Feature**: [spec.md](spec.md) | [plan.md](plan.md)

## Prerequisites

1. **Supabase project** configured with Google and Apple auth providers enabled.
2. **Google Cloud Console**: OAuth 2.0 client IDs created for iOS and Android. Web client ID needed for `google_sign_in`.
3. **Apple Developer**: Sign in with Apple capability enabled, Service ID configured in Supabase.
4. **Database migration**: Run `contracts/supabase-migration.sql` in the Supabase SQL Editor.
5. **Environment**: `.env` file with `SUPABASE_URL` and `SUPABASE_ANON_KEY` (already exists).

## iOS Setup

1. Add Google Sign-In reversed client ID to `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```
2. Add Sign in with Apple capability in Xcode: Runner → Signing & Capabilities → + Sign in with Apple.

## Android Setup

1. Add your SHA-1 fingerprint to the Google Cloud Console OAuth client.
2. No additional `AndroidManifest.xml` changes needed for `google_sign_in`.
3. Apple Sign-In on Android uses web-based flow via Supabase — no native SDK config needed.

## New Packages

Add to `pubspec.yaml` under `dependencies`:
```yaml
google_sign_in: ^6.2.2
sign_in_with_apple: ^6.1.4
```

Then run: `flutter pub get`

## Build Runner

After creating freezed models, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Files to Create (in order)

### Core Prerequisites
1. `lib/core/utils/app_validators.dart` — Composable validators
2. `lib/core/theme/components/app_form_field.dart` — Unified text input widget

### Domain Layer
3. `lib/features/auth/domain/entities/user_profile.dart` — Entity + UserRole enum + CreateProfileParams
4. `lib/features/auth/domain/repositories/auth_repository.dart` — Abstract interface
5. `lib/features/auth/domain/usecases/sign_in_with_google.dart`
6. `lib/features/auth/domain/usecases/sign_in_with_apple.dart`
7. `lib/features/auth/domain/usecases/sign_out.dart`
8. `lib/features/auth/domain/usecases/get_current_user.dart`
9. `lib/features/auth/domain/usecases/get_user_profile.dart`
10. `lib/features/auth/domain/usecases/create_user_profile.dart`
11. `lib/features/auth/domain/usecases/watch_auth_state.dart`

### Data Layer
12. `lib/features/auth/data/models/user_profile_model.dart` — Freezed model
13. Run `build_runner` to generate `.freezed.dart` and `.g.dart`
14. `lib/features/auth/data/datasources/auth_remote_data_source.dart`
15. `lib/features/auth/data/repositories/auth_repository_impl.dart`

### Presentation Layer
16. `lib/features/auth/presentation/cubit/auth_state.dart` — State classes
17. `lib/features/auth/presentation/cubit/auth_cubit.dart`
18. `lib/features/auth/presentation/pages/welcome_page.dart`
19. `lib/features/auth/presentation/pages/profile_setup_page.dart`

### Integration (Modify Existing)
20. `lib/features/auth/di/auth_injection.dart` — DI registration
21. `lib/core/di/injection_container.dart` — Call `initAuth()`, remove `AuthStateNotifier`
22. `lib/core/router/route_names.dart` — Add `welcome`, `profileSetup`
23. `lib/core/router/auth_state.dart` — Remove `AuthStateNotifier` class, keep `AuthStatus` enum
24. `lib/core/router/app_router.dart` — Use `AuthCubit` + bridge, new redirect logic, new routes
25. `lib/core/router/placeholder_pages.dart` — Remove `LoginPlaceholderPage`

## Verification

```bash
flutter analyze    # Zero errors
flutter test       # All tests pass
```
