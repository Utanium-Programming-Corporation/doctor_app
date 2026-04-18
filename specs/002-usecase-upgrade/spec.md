# Feature Specification: Core UseCase Interface Upgrade

**Feature Branch**: `002-usecase-upgrade`  
**Created**: 2026-04-12  
**Status**: Draft  
**Input**: User description: "Refactor the existing core/usecase/usecase.dart to replace the single abstract UseCase<T, Params> class with four abstract interface classes following Dart 3 best practices."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Replace Single UseCase Class with Four Typed Interfaces (Priority: P1)

As a developer building new features, I need a set of clearly typed use-case interfaces so that each use case explicitly declares whether it accepts parameters and whether it returns a future or a stream, eliminating the need for a generic NoParams workaround.

**Why this priority**: This is the core deliverable. Every subsequent feature in the project depends on having well-typed use-case interfaces. Without this change, developers must pass a meaningless `NoParams` object to use cases that take no input, adding unnecessary ceremony and reducing code clarity.

**Independent Test**: Can be fully tested by creating a sample use case implementing each of the four interfaces and verifying that the correct call signature compiles and returns the expected result type.

**Acceptance Scenarios**:

1. **Given** the core module contains the old `UseCase<T, Params>` class, **When** the upgrade is applied, **Then** the old class and `NoParams` are removed and replaced by four abstract interface classes: `UseCaseWithParams`, `UseCaseWithoutParams`, `StreamUseCaseWithParams`, and `StreamUseCaseWithoutParams`.
2. **Given** a developer creates a use case that takes parameters and returns a future, **When** they implement `UseCaseWithParams<T, Params>`, **Then** they must provide a `call(Params params)` method returning `FutureResult<T>`.
3. **Given** a developer creates a use case that takes no parameters and returns a future, **When** they implement `UseCaseWithoutParams<T>`, **Then** they must provide a `call()` method returning `FutureResult<T>` with no arguments.
4. **Given** a developer creates a use case that returns a stream, **When** they implement `StreamUseCaseWithParams<T, Params>` or `StreamUseCaseWithoutParams<T>`, **Then** the `call` method returns `StreamResult<T>`.

---

### User Story 2 - Introduce Result Type Aliases (Priority: P1)

As a developer, I need concise type aliases (`FutureResult<T>` and `StreamResult<T>`) so that use-case return types are consistent, readable, and easy to change project-wide if the error-handling strategy evolves.

**Why this priority**: The type aliases underpin every interface signature. They must exist before any interface can be defined.

**Independent Test**: Can be verified by confirming that the aliases resolve correctly at compile time and that a function returning `FutureResult<String>` is assignable to `Future<Either<Failure, String>>`.

**Acceptance Scenarios**:

1. **Given** the core module is updated, **When** a developer uses `FutureResult<T>`, **Then** it is equivalent to `Future<Either<Failure, T>>`.
2. **Given** the core module is updated, **When** a developer uses `StreamResult<T>`, **Then** it is equivalent to `Stream<Either<Failure, T>>`.

---

### User Story 3 - Add freezed and json_serializable Dependencies (Priority: P2)

As a developer, I need `freezed` and `json_serializable` available in the project so that data-layer models can be defined as immutable, boilerplate-free classes with automatic JSON serialization, following the project convention that all data models use these packages.

**Why this priority**: While not directly part of the interface refactor, adding these dependencies now is a prerequisite for every upcoming feature that defines data models. Bundling it here avoids a separate dependency-only change.

**Independent Test**: Can be verified by running the build runner and confirming that a sample freezed class generates the expected `.freezed.dart` and `.g.dart` files without errors.

**Acceptance Scenarios**:

1. **Given** the project dependencies are updated, **When** a developer adds a freezed-annotated class, **Then** `build_runner` generates the corresponding `.freezed.dart` and `.g.dart` files successfully.
2. **Given** `json_serializable` is added, **When** a model class uses `@JsonSerializable()`, **Then** `fromJson` and `toJson` methods are generated correctly.

---

### User Story 4 - Remove Legacy NoParams Class (Priority: P1)

As a developer, I should no longer need to import or instantiate a `NoParams` sentinel class when a use case takes no input, because the `UseCaseWithoutParams` and `StreamUseCaseWithoutParams` interfaces express this intent directly in their type signature.

**Why this priority**: Removing `NoParams` is part of the core interface change. If it remains, developers face conflicting patterns (old vs. new) leading to inconsistency.

**Independent Test**: Can be verified by confirming that `NoParams` no longer exists in the codebase and that any compile-time reference to it produces an error.

**Acceptance Scenarios**:

1. **Given** the old `NoParams` class exists, **When** the upgrade is applied, **Then** the class is removed from the codebase.
2. **Given** no feature code currently references `NoParams`, **When** a developer searches the codebase, **Then** zero references to `NoParams` are found.

### Edge Cases

- What happens if a future use case needs both a stream and a future return? Each use case implements exactly one interface; a feature requiring both patterns creates two separate use cases.
- What happens if a use case needs to accept optional parameters? The `Params` type can be a class with optional fields; the interface contract remains `call(Params params)`.
- What happens if `build_runner` encounters conflicts with existing generated files? Running `build_runner` with the `--delete-conflicting-outputs` flag resolves stale generated files.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The core module MUST define a `FutureResult<T>` type alias equivalent to `Future<Either<Failure, T>>`.
- **FR-002**: The core module MUST define a `StreamResult<T>` type alias equivalent to `Stream<Either<Failure, T>>`.
- **FR-003**: The core module MUST provide an `UseCaseWithParams<T, Params>` abstract interface with a single `call(Params params)` method returning `FutureResult<T>`.
- **FR-004**: The core module MUST provide an `UseCaseWithoutParams<T>` abstract interface with a single `call()` method returning `FutureResult<T>`.
- **FR-005**: The core module MUST provide a `StreamUseCaseWithParams<T, Params>` abstract interface with a single `call(Params params)` method returning `StreamResult<T>`.
- **FR-006**: The core module MUST provide a `StreamUseCaseWithoutParams<T>` abstract interface with a single `call()` method returning `StreamResult<T>`.
- **FR-007**: The old `UseCase<T, Params>` abstract class MUST be removed.
- **FR-008**: The `NoParams` class MUST be removed.
- **FR-009**: The project MUST include `freezed` and `json_serializable` as dependencies and `build_runner` and `freezed` code-generator as dev dependencies so that data models can use immutable, serializable class generation.
- **FR-010**: Any existing code referencing the old `UseCase` class or `NoParams` MUST be updated to use the new interfaces.

### Key Entities

- **UseCase Interface**: An abstract contract that defines a single `call` method. Four variants exist based on parameter presence (with/without) and return type (future/stream).
- **Result Type Aliases**: `FutureResult<T>` and `StreamResult<T>` — shorthand for the Either-wrapped return types used across all use cases.
- **Failure**: The existing error representation class used on the left side of the Either type. Unchanged by this feature.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All four abstract interface classes compile without errors and are importable from a single file.
- **SC-002**: The old `UseCase<T, Params>` class and `NoParams` class are completely absent from the codebase — zero references remain.
- **SC-003**: A developer can create a new use case by implementing one of the four interfaces with no more than one import from the core module.
- **SC-004**: Running `build_runner` after adding a sample freezed-annotated class produces generated files without errors.
- **SC-005**: All existing unit tests continue to pass after the refactor.

## Assumptions

- No feature-layer code currently depends on the old `UseCase` or `NoParams` classes beyond the core module itself, so the refactor scope is limited to core files.
- The existing `Failure` class in `core/error/failures.dart` remains unchanged and compatible with the new type aliases.
- The `dartz` package (providing `Either`) remains the project's functional-programming library.
- `freezed_annotation` and `json_annotation` are the annotation packages paired with `freezed` and `json_serializable` respectively.
- `build_runner` is only needed as a dev dependency since code generation runs at development time, not at runtime.
