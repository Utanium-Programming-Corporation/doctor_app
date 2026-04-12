# Quickstart: Core Foundation

**Feature**: 001-core-foundation
**Date**: 2026-04-07

## Prerequisites

- Flutter SDK (Dart ^3.11.4)
- A Supabase project (URL + anon key)
- Git

## Setup

### 1. Clone and checkout

```bash
git checkout 001-core-foundation
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Create environment file

Copy the example and fill in your Supabase credentials:

```bash
cp .env.example .env
```

Edit `.env`:

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

> **Warning**: Never commit `.env` to version control. It is already in `.gitignore`.

### 4. Run the app

```bash
flutter run
```

The app will:
1. Load environment variables from `.env`
2. Initialize Supabase with the configured URL and anon key
3. Register all core dependencies in the GetIt container
4. Set up global error handling (runZonedGuarded + FlutterError.onError)
5. Start the GoRouter with auth/role redirect guards
6. Display the initial screen (login placeholder or dashboard based on auth state)

### 5. Run tests

```bash
flutter test
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point — zoned error handling, init sequence, runApp |
| `lib/app.dart` | Root `MaterialApp.router` widget |
| `lib/core/di/injection_container.dart` | GetIt service locator setup |
| `lib/core/error/failures.dart` | Base `Failure` + subtypes |
| `lib/core/error/exceptions.dart` | Data-layer exception types |
| `lib/core/usecase/usecase.dart` | Abstract `UseCase<T, Params>` + `NoParams` |
| `lib/core/network/network_info.dart` | `NetworkInfo` interface + impl |
| `lib/core/router/app_router.dart` | GoRouter config with auth/role guards |
| `lib/core/router/route_names.dart` | Named route constants |
| `lib/core/utils/app_logger.dart` | PHI-safe logging utility |
| `lib/core/config/env_config.dart` | Typed access to `.env` values |

## Adding a New Feature Module

1. Create your feature folder:
   ```
   lib/features/your_feature/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   ├── data/
   │   ├── models/
   │   ├── datasources/
   │   └── repositories/
   └── presentation/
       ├── cubit/
       ├── pages/
       └── widgets/
   ```

2. Create an `init_your_feature.dart` that registers all dependencies:
   ```dart
   void initYourFeature() {
     // Register data sources
     sl.registerLazySingleton<YourRemoteDataSource>(
       () => YourRemoteDataSourceImpl(supabaseClient: sl()),
     );
     // Register repositories
     sl.registerLazySingleton<YourRepository>(
       () => YourRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
     );
     // Register use cases
     sl.registerLazySingleton(() => YourUseCase(sl()));
     // Register cubits
     sl.registerFactory(() => YourCubit(yourUseCase: sl()));
   }
   ```

3. Add a call to `initYourFeature()` in `injection_container.dart`.

4. Add your routes as children of the dashboard `ShellRoute` in `app_router.dart`.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SUPABASE_URL` | Yes | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | Yes | Your Supabase anonymous key |
