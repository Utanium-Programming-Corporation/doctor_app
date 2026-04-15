# Research: Core UseCase Interface Upgrade

**Feature**: 002-usecase-upgrade  
**Date**: 2026-04-12  
**Purpose**: Resolve technical decisions and document best practices for use case interface design and dependency additions.

## Research Task 1: Dart 3 Abstract Interface Classes

**Question**: What is the correct Dart 3 syntax for abstract interface classes used as use-case contracts?

**Findings**:
- Dart 3.0+ introduced `interface class`, `abstract interface class`, `sealed class`, and `mixin class` modifiers.
- `abstract interface class` declares a class that:
  - Cannot be instantiated directly (abstract).
  - Can only be implemented, not extended (interface).
  - Enforces that all methods must be overridden by the implementor.
- This is the correct choice for use-case contracts because:
  - Use cases should not inherit behavior from a base class — they define their own logic.
  - `implements` (not `extends`) is the intended relationship.
  - It prevents accidental inheritance of default implementations.

**Decision**: Use `abstract interface class` for all four use-case interfaces.  
**Rationale**: Strongest enforcement — prevents extension, requires explicit implementation.  
**Alternatives considered**:
- `abstract class`: Allows `extends`, which could lead to unintentional base-class coupling. Rejected.
- `mixin class`: Inappropriate for contracts that define a single callable method. Rejected.

## Research Task 2: Type Alias Syntax for Result Types

**Question**: What is the correct Dart syntax for generic type aliases?

**Findings**:
- Dart supports generic type aliases via `typedef`:
  ```dart
  typedef FutureResult<T> = Future<Either<Failure, T>>;
  typedef StreamResult<T> = Stream<Either<Failure, T>>;
  ```
- These are fully transparent at compile time — no runtime overhead.
- The alias is expanded during type checking, so `FutureResult<String>` is identical to `Future<Either<Failure, String>>` in all contexts.
- Aliases can be used in return types, parameter types, and variable declarations.

**Decision**: Use `typedef` for both `FutureResult<T>` and `StreamResult<T>`.  
**Rationale**: Idiomatic Dart, zero overhead, improves readability across all use cases.  
**Alternatives considered**:
- Wrapper classes (e.g., `class FutureResult<T> { final Future<Either<Failure, T>> value; }`): Adds indirection and boxing. Rejected.
- No alias (spell out full type everywhere): Verbose and error-prone. Rejected.

## Research Task 3: freezed + json_serializable Dependency Setup

**Question**: What are the correct package names and version compatibility constraints for adding freezed code generation?

**Findings**:
- **Runtime dependencies** (in `dependencies`):
  - `freezed_annotation`: Provides `@freezed` and `@unfreezed` annotations. Required at runtime because generated code imports it.
  - `json_annotation`: Provides `@JsonSerializable`, `@JsonKey`, etc. Required at runtime for the same reason.
- **Dev dependencies** (in `dev_dependencies`):
  - `freezed`: The code generator itself. Only needed at build time.
  - `json_serializable`: The code generator for JSON. Only needed at build time.
  - `build_runner`: The build system that invokes the generators. Only needed at build time.
- **Version strategy**: Use caret syntax (e.g., `^2.5.0`) to allow minor/patch updates. The `freezed` generator and `freezed_annotation` must be compatible — using latest stable of both ensures this.
- **build_runner command**: `dart run build_runner build --delete-conflicting-outputs`
- **Analysis exclusion**: Add `*.freezed.dart` and `*.g.dart` to `.gitignore`-style exclusion in `analysis_options.yaml` under `analyzer > exclude` to suppress warnings on generated files.

**Decision**: Add `freezed_annotation` and `json_annotation` to dependencies; add `freezed`, `json_serializable`, and `build_runner` to dev_dependencies.  
**Rationale**: Standard Flutter/Dart setup for freezed code generation. Annotations must be runtime deps because generated code imports them.  
**Alternatives considered**:
- Using only `json_serializable` without freezed: Doesn't provide immutability, copyWith, or union types. Rejected — constitution mandates freezed.
- Using `dart_mappable` instead: Less community adoption, different API surface. Rejected — constitution explicitly names freezed + json_serializable.

## Research Task 4: Removing equatable Import from usecase.dart

**Question**: After removing `NoParams`, is the `equatable` import still needed in `usecase.dart`?

**Findings**:
- The current `usecase.dart` imports `equatable` solely for the `NoParams extends Equatable` class.
- The four new interfaces do not extend or use `Equatable` — they only reference `Either`, `Failure`, `Future`, and `Stream`.
- After removing `NoParams`, the `equatable` import becomes unused and should be removed.

**Decision**: Remove the `equatable` import from `usecase.dart`.  
**Rationale**: Dead import after `NoParams` removal.  
**Alternatives considered**: None — keeping unused imports violates Dart lint rules.

## Research Task 5: Existing Code Impact Assessment

**Question**: Are there any files outside `usecase.dart` that reference `UseCase` or `NoParams`?

**Findings**:
- Searched entire `lib/` directory for imports of `usecase.dart`, references to `UseCase`, and references to `NoParams`.
- **Result**: Zero references found outside `lib/core/usecase/usecase.dart` itself.
- No feature code exists yet that implements use cases.
- The `injection_container.dart` does not import or reference `usecase.dart`.
- Test files do not reference `usecase.dart`.

**Decision**: Refactoring scope is confirmed to `usecase.dart` and `pubspec.yaml` only. No cascading changes required.  
**Rationale**: No consumers of the old API exist.  
**Alternatives considered**: N/A — this is a factual assessment, not a design choice.

## Summary of All Decisions

| # | Decision | Outcome |
|---|----------|---------|
| 1 | Interface class modifier | `abstract interface class` (Dart 3) |
| 2 | Result type aliases | `typedef FutureResult<T>` and `typedef StreamResult<T>` |
| 3 | freezed dependency split | Annotations in deps, generators + build_runner in dev_deps |
| 4 | equatable import | Remove from usecase.dart (dead after NoParams removal) |
| 5 | Refactoring scope | usecase.dart + pubspec.yaml only; zero cascading changes |
