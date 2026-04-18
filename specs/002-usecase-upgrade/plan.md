# Implementation Plan: Core UseCase Interface Upgrade

**Branch**: `002-usecase-upgrade` | **Date**: 2026-04-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-usecase-upgrade/spec.md`

## Summary

Replace the single `UseCase<T, Params>` abstract class and `NoParams` sentinel in `core/usecase/usecase.dart` with four Dart 3 abstract interface classes (`UseCaseWithParams`, `UseCaseWithoutParams`, `StreamUseCaseWithParams`, `StreamUseCaseWithoutParams`) and two result-type aliases (`FutureResult<T>`, `StreamResult<T>`). Additionally, add `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, and `build_runner` to `pubspec.yaml` to enable immutable data-model code generation for all future features.

## Technical Context

**Language/Version**: Dart 3.11.4+ / Flutter latest stable  
**Primary Dependencies**: dartz (Either), equatable, freezed, freezed_annotation, json_annotation, json_serializable, build_runner  
**Storage**: N/A (core-only refactor, no database changes)  
**Testing**: flutter_test, mocktail, bloc_test  
**Target Platform**: iOS, Android  
**Project Type**: mobile-app  
**Performance Goals**: N/A (no runtime behavior change; compile-time-only refactor)  
**Constraints**: N/A  
**Scale/Scope**: 23 features planned; this change underpins every future use case

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Principle | Verdict | Notes |
|---|-----------|---------|-------|
| I | Clean Architecture | ✅ PASS | This feature directly implements the use-case interface contracts mandated by Principle I. Domain layer remains pure Dart — no Flutter or Supabase imports. |
| II | Type-Safe Functional Error Handling | ✅ PASS | All interfaces return `Either<Failure, T>`. Adding freezed + json_serializable aligns with the data-model mandate. |
| III | Security & HIPAA Compliance | ✅ N/A | No tables, no data, no PHI involved. |
| IV | Feature-Modular Organization | ✅ PASS | All changes are in `core/usecase/` and `pubspec.yaml`. No feature folders affected. |
| V | Cubit-Default State Management | ✅ N/A | No state management involved. |
| VI | Supabase-First Backend | ✅ N/A | No backend changes. |
| VII | UI File Size Discipline | ✅ N/A | No UI files created or modified. |
| VIII | Unified Text Input | ✅ N/A | No UI files created or modified. |

**Gate result: PASS** — no violations, no justifications needed.

## Project Structure

### Documentation (this feature)

```text
specs/002-usecase-upgrade/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── usecase/
│   │   └── usecase.dart          # MODIFIED: 4 interfaces + 2 type aliases replace UseCase + NoParams
│   ├── error/
│   │   ├── failures.dart         # UNCHANGED: Failure class used by type aliases
│   │   └── exceptions.dart       # UNCHANGED
│   ├── di/
│   │   └── injection_container.dart  # UNCHANGED
│   ├── network/
│   │   └── network_info.dart     # UNCHANGED
│   └── ...
├── features/                     # UNCHANGED (no feature code exists yet)
├── app.dart                      # UNCHANGED
└── main.dart                     # UNCHANGED

pubspec.yaml                      # MODIFIED: add freezed, json_serializable, build_runner deps

test/
└── core/
    └── usecase/
        └── usecase_test.dart     # NEW: unit tests for interface compliance
```

**Structure Decision**: Existing Flutter mobile app structure. This feature modifies two files (`usecase.dart`, `pubspec.yaml`) and adds one test file. No structural changes.

## Complexity Tracking

> No Constitution Check violations. This table is intentionally empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
