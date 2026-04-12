<!--
  SYNC IMPACT REPORT
  ==================
  Version change: N/A → 1.0.0 (initial ratification)
  Modified principles: N/A (all new)
  Added sections:
    - Core Principles (6 principles)
    - Technology Stack & Constraints
    - Development Workflow & Quality Gates
    - Governance
  Removed sections: N/A
  Templates requiring updates:
    - .specify/templates/plan-template.md — ✅ compatible (Constitution
      Check section will be populated per these principles)
    - .specify/templates/spec-template.md — ✅ compatible (requirements
      and success criteria align with principle-driven gates)
    - .specify/templates/tasks-template.md — ✅ compatible (phase
      structure supports feature-modular delivery)
  Follow-up TODOs: None
-->

# Doctors App Constitution

## Core Principles

### I. Clean Architecture (NON-NEGOTIABLE)

Every feature MUST follow three-layer separation:

- **Domain**: Entities (Equatable), repository interfaces (abstract),
  use cases returning `Either<Failure, T>`. Pure Dart only — zero
  Flutter or Supabase imports.
- **Data**: Models extending entities with `fromJson`/`toJson`, remote
  data sources (Supabase), local data sources (cache), repository
  implementations that catch exceptions and map to `Failure`.
- **Presentation**: Cubits/Blocs, states (Equatable), pages, widgets.
  Pages MUST only communicate with cubits; cubits MUST only call
  use cases.

Cross-cutting code lives in `core/` (error, usecase, network, theme,
router, di, utils, constants, localization). No feature folder may
import from another feature folder directly — shared logic MUST be
extracted to `core/` or a shared domain contract.

**Rationale**: Enforces testability, replaceability, and prevents
spaghetti coupling across a 23-feature codebase.

### II. Type-Safe Functional Error Handling

- All use cases MUST return `Either<Failure, T>` (Dartz). Raw
  exceptions MUST NOT cross layer boundaries.
- All entities and states MUST extend `Equatable`.
- Data models MUST use `freezed` + `json_serializable` for immutable,
  boilerplate-free serialization.
- Nullable types MUST be used intentionally; implicit nulls are
  prohibited. Every nullable field MUST have documented semantics.

**Rationale**: Eliminates runtime type errors and unhandled exceptions
in a healthcare system where data integrity is critical.

### III. Security & HIPAA Compliance (NON-NEGOTIABLE)

- Row Level Security (RLS) MUST be enabled on every Supabase table.
  Every domain table MUST include a `clinic_id` column enforced by
  RLS policies referencing `auth.uid()` and `current_user_role()`.
- An append-only `audit_log` table MUST record who, what, when, and
  old/new values (JSONB) for every sensitive operation via DB triggers.
- Protected Health Information (PHI) MUST NOT appear in application
  logs, error messages, or client-side storage.
- Patient document URLs MUST use signed URLs with expiration; public
  bucket URLs are prohibited for PHI-adjacent content.
- Role-based access MUST be enforced at both UI level
  (`PermissionGuard` widget) and DB level (defense in depth).
- Session timeout and biometric lock (`local_auth`) MUST be
  implemented on mobile clients.

**Rationale**: The system handles medical records and patient data
subject to HIPAA-style compliance requirements.

### IV. Feature-Modular Organization

- Each feature MUST be a self-contained folder under `lib/features/`
  containing `domain/`, `data/`, and `presentation/` subdirectories.
- Dependency injection MUST use GetIt with per-feature `initX()`
  registration functions called from a central `injection_container.dart`.
- Routing MUST use GoRouter with `redirect` reading auth state and
  role from a global `AuthCubit`; nested `ShellRoute`s for the main
  dashboard shell.
- Features MUST NOT import implementation details from other features.
  Cross-feature communication MUST go through use cases or shared
  domain contracts in `core/`.

**Rationale**: With 8 modules spanning 23 feature areas, strict
module boundaries prevent coupling and enable parallel development.

### V. Cubit-Default State Management

- Cubit MUST be the default state management solution for all features.
- Bloc (event-driven) MUST only be used when complex event streams
  are required (e.g., real-time queue subscriptions, chat, concurrent
  Supabase Realtime channels).
- The choice of Bloc over Cubit MUST be documented in the feature's
  plan with a justification referencing the specific event complexity.
- All states MUST extend `Equatable` and be immutable.

**Rationale**: Cubit reduces boilerplate for the majority of screens;
Bloc is reserved for genuinely event-driven flows to avoid
over-engineering.

### VI. Supabase-First Backend

- Supabase Auth MUST be the sole authentication provider (email/password
  + phone OTP).
- Business logic that involves data integrity (stock adjustment on
  invoice, waitlist promotion on cancellation, audit logging) MUST be
  implemented as Postgres functions and triggers, not in client code.
- Real-time features (queue tokens, messages, appointment changes,
  stock movements) MUST use Supabase Realtime subscriptions.
- External integrations (SMS/WhatsApp via Twilio, email via SendGrid,
  push via FCM) MUST be handled by Supabase Edge Functions (Deno),
  never called directly from the Flutter client.
- Scheduled operations (expiry scans, reorder checks, reminder
  dispatch) MUST use `pg_cron`.
- File storage MUST use Supabase Storage with bucket-level RLS.

**Rationale**: Centralizing logic at the database and edge layer
ensures consistency across all clients and eliminates client-side
trust assumptions.

## Technology Stack & Constraints

- **Framework**: Flutter (Dart SDK ^3.11.4)
- **State Management**: flutter_bloc (Cubit default, Bloc when justified)
- **DI**: get_it
- **Routing**: go_router with auth/role guards
- **Error Handling**: dartz (Either), equatable
- **Code Generation**: freezed + json_serializable
- **Backend**: Supabase (Auth, Database, Realtime, Storage,
  Edge Functions, pg_cron)
- **Offline**: Read-only cache (Hive or Isar) for today's schedule
  and queue; online-only for writes in v1
- **Design System**: Figma-driven tokens (SF Pro Display/Text,
  primary #00438F, secondary #83A7D2, accent #0ABDBD)
- **Target Platforms**: iOS, Android (web/desktop deferred)
- **Multi-tenancy**: Every domain table MUST include `clinic_id`;
  single codebase with role-based routing
- **Internationalization**: Arabic/English via easy_localization
- **Performance**: 60 fps UI target; Realtime subscription latency
  < 2 seconds for queue and chat updates
- **Compliance**: HIPAA-style; Supabase Team/Enterprise plan with BAA
  required before production deployment

## Development Workflow & Quality Gates

- **Architecture Gate**: Every new feature MUST pass a Constitution
  Check (verifying Clean Architecture layers, RLS presence, audit
  logging) before implementation begins.
- **Code Review**: All PRs MUST verify compliance with these
  principles. Reviewers MUST check for PHI leaks, missing RLS
  policies, and cross-feature import violations.
- **Testing Strategy**:
  - Domain layer: unit tests for every use case (mocktail + bloc_test)
  - Data layer: unit tests for repository implementations with mocked
    data sources
  - Presentation layer: widget tests for critical user flows
  - Integration tests for cross-module flows (e.g., billing triggering
    stock adjustment)
- **Build Order**: Features MUST follow the phased roadmap (Foundation
  → Scheduling → Queue/Chat → Staff → Inventory → EHR → Messaging
  Expansion → Compliance Hardening) to ensure dependencies are
  satisfied.
- **Branching**: Sequential branch numbering per speckit convention.
- **Complexity Justification**: Any deviation from these principles
  (e.g., additional external packages, direct feature-to-feature
  imports) MUST be documented with rationale and a simpler rejected
  alternative.

## Governance

This constitution is the supreme authority for all development
decisions in the Doctors App project. When a conflict arises between
this constitution and any other practice, specification, or plan,
this constitution prevails.

- **Amendments**: Any change to this constitution MUST be documented
  with a version bump, rationale, and migration plan for affected
  code.
- **Versioning**: Constitution follows semantic versioning —
  MAJOR for principle removals/redefinitions, MINOR for new
  principles or material expansions, PATCH for clarifications
  and typo fixes.
- **Compliance Review**: Every feature specification and implementation
  plan MUST include a Constitution Check section verifying alignment
  with all six core principles.
- **Enforcement**: Violations discovered in review MUST be resolved
  before merge. No exceptions without a documented governance waiver
  approved and recorded in the PR description.

**Version**: 1.0.0 | **Ratified**: 2026-04-07 | **Last Amended**: 2026-04-07
