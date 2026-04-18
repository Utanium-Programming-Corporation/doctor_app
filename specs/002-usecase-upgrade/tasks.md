# Tasks: Core UseCase Interface Upgrade

**Input**: Design documents from `/specs/002-usecase-upgrade/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Not explicitly requested in the feature specification. Verification tasks included for compilation and existing test regression.

**Organization**: Tasks are grouped by user story. US1, US2, and US4 (all P1) are co-dependent changes to a single file and are merged into one phase. US3 (P2) is an independent phase.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: No project initialization needed — project already exists with all tooling configured.

- [x] T001 Verify current project compiles cleanly by running `flutter analyze` from project root
- [x] T002 Confirm no existing code references `UseCase` or `NoParams` outside `lib/core/usecase/usecase.dart` by searching `lib/` directory

**Checkpoint**: Clean baseline confirmed — safe to proceed with refactoring

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No foundational phase needed. All changes are leaf-level modifications to existing files with no shared infrastructure to set up first.

**⚠️ SKIPPED**: This feature modifies existing core infrastructure rather than building on top of it. Phase 1 verification is the only prerequisite.

---

## Phase 3: User Stories 1, 2 & 4 — UseCase Interface Replacement (Priority: P1) 🎯 MVP

**Goal**: Replace the single `UseCase<T, Params>` abstract class and `NoParams` sentinel with four Dart 3 abstract interface classes and two result-type aliases in a single file.

**Independent Test**: Run `flutter analyze` — zero errors. Import `usecase.dart` in any Dart file and confirm all four interfaces and both type aliases are accessible. Confirm `UseCase` and `NoParams` no longer exist.

**Covers**:
- US1: Replace single UseCase class with four typed interfaces
- US2: Introduce FutureResult\<T\> and StreamResult\<T\> type aliases
- US4: Remove legacy NoParams class

### Implementation

- [x] T003 [US1] [US2] [US4] Rewrite `lib/core/usecase/usecase.dart` — remove `UseCase<T, Params>` class, remove `NoParams` class, remove `equatable` import, add `typedef FutureResult<T> = Future<Either<Failure, T>>`, add `typedef StreamResult<T> = Stream<Either<Failure, T>>`, add `abstract interface class UseCaseWithParams<T, Params>` with `FutureResult<T> call(Params params)`, add `abstract interface class UseCaseWithoutParams<T>` with `FutureResult<T> call()`, add `abstract interface class StreamUseCaseWithParams<T, Params>` with `StreamResult<T> call(Params params)`, add `abstract interface class StreamUseCaseWithoutParams<T>` with `StreamResult<T> call()`
- [x] T004 [US1] Run `flutter analyze` to verify `lib/core/usecase/usecase.dart` compiles without errors
- [x] T005 [US4] Search entire `lib/` directory for any remaining references to `UseCase` (old class name) or `NoParams` and confirm zero results

**Checkpoint**: Core use-case interfaces are live. All four interfaces compile and are importable. Old UseCase and NoParams are gone. This is the MVP.

---

## Phase 4: User Story 3 — Add freezed & json_serializable Dependencies (Priority: P2)

**Goal**: Add code-generation dependencies to `pubspec.yaml` so that future features can define immutable, serializable data models using freezed.

**Independent Test**: Run `flutter pub get` — resolves without errors. Run `dart run build_runner build --delete-conflicting-outputs` — exits cleanly (no sources to generate yet, but the tool chain is functional).

### Implementation

- [x] T006 [P] [US3] Add `freezed_annotation` and `json_annotation` to `dependencies` section in `pubspec.yaml`
- [x] T007 [P] [US3] Add `freezed`, `json_serializable`, and `build_runner` to `dev_dependencies` section in `pubspec.yaml`
- [x] T008 [US3] Run `flutter pub get` to resolve all new dependencies and verify no version conflicts
- [x] T009 [US3] Add `*.freezed.dart` and `*.g.dart` to `analyzer > exclude` list in `analysis_options.yaml` to suppress lint warnings on generated files

**Checkpoint**: Code-generation toolchain is ready. Any future feature can now use `@freezed` annotations.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation across all user stories

- [x] T010 Run full `flutter analyze` to confirm zero warnings and zero errors across entire project
- [x] T011 Run `flutter test` to confirm all existing tests still pass (regression check per SC-005)
- [x] T012 Run quickstart.md verification steps: `grep -r "NoParams\|class UseCase<" lib/` returns no output

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 3 (US1+US2+US4)**: Depends on Phase 1 completion
- **Phase 4 (US3)**: Independent of Phase 3 — can run in parallel
- **Phase 5 (Polish)**: Depends on Phase 3 AND Phase 4 completion

### User Story Dependencies

- **US1 + US2 + US4 (P1)**: Co-dependent — all modify the same file (`usecase.dart`). Must be done together in a single task (T003).
- **US3 (P2)**: Fully independent — modifies only `pubspec.yaml` and `analysis_options.yaml`. No dependency on US1/US2/US4.

### Within Each Phase

- Phase 3: T003 → T004 → T005 (sequential — rewrite, then verify, then search)
- Phase 4: T006 ∥ T007 (parallel — different sections of same file), then T008 → T009 (sequential)
- Phase 5: T010 → T011 → T012 (sequential — analyze, test, then grep)

### Parallel Opportunities

```
Phase 1:  T001 ∥ T002
               │
          ┌────┴────┐
Phase 3:  T003→T004→T005    Phase 4: T006 ∥ T007 → T008 → T009
          └────┬────┘                └─────────┬──────────┘
               └──────────┬───────────────────┘
Phase 5:            T010 → T011 → T012
```

---

## Implementation Strategy

### MVP Scope

**MVP = Phase 3 (US1 + US2 + US4)**: After completing T003–T005, the project has fully typed use-case interfaces and the old UseCase/NoParams are removed. This is the minimum viable increment that delivers the core value of the feature.

### Incremental Delivery

1. **Increment 1 (MVP)**: Phase 1 + Phase 3 → typed use-case interfaces live
2. **Increment 2**: Phase 4 → freezed/json_serializable toolchain ready
3. **Increment 3**: Phase 5 → full validation and regression check
