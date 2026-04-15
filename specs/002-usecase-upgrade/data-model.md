# Data Model: Core UseCase Interface Upgrade

**Feature**: 002-usecase-upgrade  
**Date**: 2026-04-12

## Overview

This feature defines abstract interface contracts rather than data entities. There are no database tables, no persisted models, and no state objects. The "entities" here are the type-level contracts that all future use cases must implement.

## Type Aliases

### FutureResult\<T\>

| Attribute | Value |
|-----------|-------|
| **Definition** | `typedef FutureResult<T> = Future<Either<Failure, T>>` |
| **Purpose** | Standard return type for all async use cases that return a single value |
| **Dependencies** | `Either` from `dartz`, `Failure` from `core/error/failures.dart` |

### StreamResult\<T\>

| Attribute | Value |
|-----------|-------|
| **Definition** | `typedef StreamResult<T> = Stream<Either<Failure, T>>` |
| **Purpose** | Standard return type for all reactive use cases that emit a stream of values |
| **Dependencies** | `Either` from `dartz`, `Failure` from `core/error/failures.dart` |

## Abstract Interface Classes

### UseCaseWithParams\<T, Params\>

| Attribute | Value |
|-----------|-------|
| **Type** | `abstract interface class` |
| **Type Parameters** | `T` (success type), `Params` (input type) |
| **Method** | `FutureResult<T> call(Params params)` |
| **Usage** | Use cases that accept input and return a single async result |
| **Example** | `GetPatientById implements UseCaseWithParams<Patient, String>` |

### UseCaseWithoutParams\<T\>

| Attribute | Value |
|-----------|-------|
| **Type** | `abstract interface class` |
| **Type Parameters** | `T` (success type) |
| **Method** | `FutureResult<T> call()` |
| **Usage** | Use cases that require no input and return a single async result |
| **Example** | `GetCurrentUser implements UseCaseWithoutParams<User>` |

### StreamUseCaseWithParams\<T, Params\>

| Attribute | Value |
|-----------|-------|
| **Type** | `abstract interface class` |
| **Type Parameters** | `T` (success type), `Params` (input type) |
| **Method** | `StreamResult<T> call(Params params)` |
| **Usage** | Use cases that accept input and return a reactive stream of results |
| **Example** | `WatchQueueTokens implements StreamUseCaseWithParams<List<Token>, String>` |

### StreamUseCaseWithoutParams\<T\>

| Attribute | Value |
|-----------|-------|
| **Type** | `abstract interface class` |
| **Type Parameters** | `T` (success type) |
| **Method** | `StreamResult<T> call()` |
| **Usage** | Use cases that require no input and return a reactive stream of results |
| **Example** | `WatchNotifications implements StreamUseCaseWithoutParams<List<Notification>>` |

## Removed Entities

### UseCase\<T, Params\> (REMOVED)

| Attribute | Value |
|-----------|-------|
| **Was** | `abstract class UseCase<T, Params>` |
| **Reason** | Replaced by four specific interfaces that encode parameter-presence and return-type in their type signature |

### NoParams (REMOVED)

| Attribute | Value |
|-----------|-------|
| **Was** | `class NoParams extends Equatable` |
| **Reason** | Eliminated by the `*WithoutParams` interface variants. Use cases that take no input simply implement `UseCaseWithoutParams` or `StreamUseCaseWithoutParams` with a parameterless `call()` |

## Relationships

```text
FutureResult<T> ──uses──▶ Either<Failure, T>
StreamResult<T> ──uses──▶ Either<Failure, T>

UseCaseWithParams<T, Params>    ──returns──▶ FutureResult<T>
UseCaseWithoutParams<T>         ──returns──▶ FutureResult<T>
StreamUseCaseWithParams<T, Params> ──returns──▶ StreamResult<T>
StreamUseCaseWithoutParams<T>      ──returns──▶ StreamResult<T>

All interfaces ──depend on──▶ Failure (from core/error/failures.dart)
All interfaces ──depend on──▶ Either  (from dartz package)
```

## Validation Rules

- Each use case class MUST implement exactly one interface (not multiple).
- The `Params` type parameter MUST be a concrete class (not `dynamic` or `Object`). If a use case accepts multiple inputs, they should be grouped in a dedicated params class.
- `T` (success type) MUST NOT be `void` — use `Unit` from dartz for side-effect-only use cases.
