# Clinic Management System — Detailed Plan

Here's a comprehensive plan organized around your stack (Flutter + BLoC/Cubit + GetIt + GoRouter + Dartz + Equatable, Clean Architecture with domain/data/presentation, Supabase backend).

---

## 1. High-Level Architecture

**Clean Architecture, three layers per feature:**

- **Domain**: Entities (Equatable), repository interfaces (abstract), use cases returning `Either<Failure, T>` (Dartz). Pure Dart, zero Flutter/Supabase imports.
- **Data**: Models (extend entities, with `fromJson`/`toJson`), remote data sources (Supabase client), local data sources (Hive/Isar for cache & offline), repository implementations that catch exceptions and map to `Failure`.
- **Presentation**: Cubits/Blocs, states (Equatable), pages, widgets. Pages only talk to cubits; cubits only call use cases.

**Cross-cutting:**
- `core/` folder: `error/` (Failure, Exceptions), `usecase/` (base UseCase class), `network/` (NetworkInfo, Supabase client wrapper), `utils/`, `constants/`, `theme/`, `localization/`, `router/` (GoRouter config with auth guards & role guards), `di/` (GetIt service locator with feature-based registration modules).
- **Dependency Injection**: one `injection_container.dart` calling per-feature `initX()` registration functions — keeps SOLID's DIP clean.
- **Routing**: GoRouter with a `redirect` that reads auth state + role from a global `AuthCubit`; nested ShellRoutes for the main dashboard shell.
- **State**: Cubit by default (simpler), Bloc only where you need complex event streams (e.g., real-time queue, chat).

**Given the scope (23 feature areas), treat this as a modular monorepo.** Consider splitting into packages later: `core`, `features_scheduling`, `features_inventory`, `features_ehr`, etc. Start as folders, graduate to packages when build times hurt.

---

## 2. Supabase Backend Design

### 2.1 Auth & Roles
- Supabase Auth with email/password + phone OTP.
- Custom `profiles` table linked to `auth.users` with `role` enum: `super_admin`, `clinic_admin`, `doctor`, `nurse`, `receptionist`, `pharmacist`, `patient`.
- **Row Level Security (RLS)** on every table — this is how you get HIPAA-style role-based access. Policies reference `auth.uid()` and a helper SQL function `current_user_role()`.
- Multi-tenancy: every domain table has a `clinic_id` column; RLS ensures users only see their clinic's rows.

### 2.2 Core Tables (grouped)

- **Tenancy & People**: `clinics`, `locations`, `profiles`, `patients`, `staff`, `staff_clinic_assignments`.
- **Scheduling**: `appointments`, `appointment_types`, `recurrence_rules`, `waitlist_entries`, `provider_availability`, `time_off_requests`, `shifts`, `shift_templates`.
- **Queue & Triage**: `queue_tokens`, `triage_assessments`, `rooms`.
- **Chat & Messaging**: `conversations`, `messages`, `message_templates`, `scheduled_messages`, `notification_log`.
- **Inventory**: `products`, `product_lots` (for expiry & recall), `stock_movements`, `suppliers`, `purchase_orders`, `purchase_order_items`, `reorder_rules`.
- **Billing/EHR link**: `invoices`, `invoice_items` (triggers stock movements), `encounters`, `soap_notes`, `lab_results`, `prescriptions`, `attachments`.
- **Audit**: `audit_log` (append-only, written by DB triggers on every sensitive table).

### 2.3 Supabase Features to Use

- **Postgres functions & triggers**: auto-stock adjustment on invoice insert; audit log triggers; waitlist promotion on cancellation.
- **Realtime**: subscribe to `queue_tokens`, `messages`, `appointments`, `stock_movements` for live UI.
- **Storage buckets**: `patient-documents`, `lab-results`, `chat-attachments`, `product-images`. Bucket-level RLS.
- **Edge Functions** (Deno) for anything that shouldn't live in the client:
  - Sending SMS/WhatsApp/email via Twilio/Meta/SendGrid (reminders, bulk blasts, waitlist notifications).
  - Recurrence expansion (materializing recurring appointments).
  - Scheduled reminder dispatcher (cron via `pg_cron` calling the edge function).
  - Triage scoring logic.
- **pg_cron**: daily expiry scan, reorder-point scan, reminder scheduler tick (every 5–15 min).

---

## 3. Feature Modules & Mapping to Requirements

I'll group your 23 features into 8 cohesive Flutter modules. Each module follows the three-layer structure.

### Module A — Auth & Tenancy
Covers login, clinic selection (for multi-clinic admins), role bootstrap, profile. Feeds every other module via `AuthCubit` exposing `currentUser`, `currentClinicId`, `role`.

### Module B — Scheduling & Calendar
**Covers features 1, 6, 8, 9, 10.**

- **Domain entities**: `Appointment`, `AppointmentType`, `RecurrenceRule`, `Provider`, `TimeSlot`, `WaitlistEntry`.
- **Use cases**: `GetAppointmentsForRange`, `CreateAppointment`, `RescheduleAppointment` (drag-and-drop), `CancelAppointment`, `CreateRecurringSeries`, `GetAvailableSlots`, `BookOnlineSlot`, `JoinWaitlist`, `PromoteFromWaitlist`.
- **Key logic**: Double-booking prevention via a Postgres `EXCLUDE` constraint using `tstzrange` on `(provider_id, time_range)`. When an appointment is cancelled, a trigger queues a waitlist promotion job handled by an edge function that notifies the next patient.
- **Recurrence**: store an RRULE-style string (RFC 5545) in `recurrence_rules`; expand on read for a given window. For physical therapy / diet series, you materialize N occurrences upfront so individual instances can be rescheduled.
- **Presentation**: A custom calendar widget (consider `syncfusion_flutter_calendar` for daily/weekly/monthly + drag-and-drop, or build on `table_calendar` + custom day view). Color-coded by provider or appointment type (user toggle). Filter chips for providers, rooms, types.
- **Online booking**: a separate public route (no auth required, or patient auth) exposing only availability — backed by a Supabase RPC that returns free slots without leaking other patient data.

### Module C — Waiting Room, Queue & Triage
**Covers features 2, 11, 12.**

- **Entities**: `QueueToken` (number, status: waiting/called/in_progress/done/no_show, priority, assigned_provider), `TriageAssessment` (vitals, acuity level 1–5 ESI-style), `Room`.
- **Check-in flow**: receptionist or kiosk creates a `queue_token`; trigger auto-assigns next number per clinic per day.
- **Triage**: a short form producing an acuity score; higher acuity jumps priority. Load balancing use case picks the provider with the lowest current queue depth matching the required specialty.
- **Realtime**: Flutter subscribes to `queue_tokens` changes; kiosk display screen is a separate route showing only `waiting` + `called` tokens for that clinic. Patient app shows their own token + position.
- **Bloc** (not cubit) here because you'll handle a stream of realtime events plus user actions.

### Module D — Messaging & Notifications
**Covers features 3, 7, 13.**

- **Entities**: `Conversation`, `Message`, `MessageTemplate`, `ScheduledMessage`, `NotificationChannel` (sms/email/whatsapp/push).
- **In-app chat**: `conversations` + `messages` tables, realtime subscription, attachment upload to `chat-attachments` bucket. One conversation per patient–clinic pair (or per staff member if needed).
- **Templates & bulk**: admin UI to create templates with variables (`{{patient_name}}`, `{{appt_time}}`). Bulk send = select patient segment (filter builder) → enqueue a `scheduled_messages` row → edge function processes and calls the provider (Twilio for SMS/WhatsApp, SendGrid for email, FCM for push).
- **Reminders**: on appointment creation, auto-schedule reminders at configurable offsets (e.g., 24h, 2h before). Stored in `scheduled_messages`; cron dispatcher sends them. Two-way confirmation: reply "YES/NO" handled by a webhook edge function updating `appointments.confirmation_status`.
- **Follow-ups**: trigger on appointment completion to schedule a follow-up message at X days.

### Module E — Staff Management
**Covers features 5, 19, 20.**

- **Entities**: `StaffMember`, `Shift`, `ShiftTemplate`, `TimeOffRequest`, `StaffCalendarEvent` (union view).
- **Use cases**: assign shifts, request time off, approve/deny (manager role), swap shifts, view master calendar.
- **Rules engine**: validation layer for self-scheduling (min rest hours, max hours/week, required coverage per role). Implemented as pure domain services so rules are testable.
- **Views**: master calendar (all staff rows × days), per-staff personal calendar, pending approvals list for managers.

### Module F — Inventory
**Covers features 4, 14, 15, 16, 17, 18.**

- **Entities**: `Product`, `ProductLot` (lot_number, expiry_date, quantity, location), `StockMovement` (in/out/adjust/transfer), `Supplier`, `PurchaseOrder`, `ReorderRule`.
- **Stock levels**: never store `current_stock` as a mutable column — compute it as `SUM(stock_movements.qty)` per product/lot/location via a view or materialized view refreshed on movement. Keeps audit trail perfect.
- **Auto-adjust on billing**: Postgres trigger on `invoice_items` insert creates corresponding `stock_movements` rows (FIFO by expiry for lot selection).
- **Expiry & recall**: daily `pg_cron` scans `product_lots` for expiry within 30/60/90 days and creates alerts. Recall flow: mark a lot as recalled → query which patients received it via `invoice_items` join → bulk message them via Module D.
- **Reorder**: when computed stock < `reorder_point`, create a draft purchase order or alert.
- **Barcode/QR**: Flutter uses `mobile_scanner` package; scan → lookup product/lot → open stock-take or dispense screen. Generate QR for lots via `qr_flutter`.
- **Multi-location**: `stock_movements.location_id` enables per-site inventory.

### Module G — EHR/EMR
**Covers feature 21.**

- **Entities**: `Patient`, `Encounter`, `SoapNote` (Subjective, Objective, Assessment, Plan), `Prescription`, `LabResult`, `Attachment`, `Vital`, `Allergy`, `Problem`, `MedicationHistory`.
- **Use cases**: open chart, create encounter, write SOAP note, prescribe (links to inventory for in-clinic dispensing), upload lab PDF, view timeline.
- **Design note**: the patient chart is the most screen-heavy view. Build it as a tabbed shell (Overview / Encounters / Medications / Labs / Documents / Billing) each as its own cubit to keep state isolated.
- **Attachments**: Supabase Storage with signed URLs; never expose public URLs for PHI.

### Module H — Analytics & Admin
**Covers features 22, 23.**

- **Analytics**: pre-built SQL views in Postgres for KPIs (revenue by day/provider, no-show rate, avg wait time, staff utilization, top meds). Flutter fetches via RPC and renders with `fl_chart` or `syncfusion_flutter_charts`.
- **Security & compliance**:
  - RLS on everything.
  - `audit_log` via triggers on sensitive tables (who, what, when, old/new values as JSONB).
  - Role-based UI: a `PermissionGuard` widget that hides/disables actions based on role; enforced again at DB level (defense in depth).
  - Encryption: Supabase handles at-rest; enforce TLS in transit; consider column-level encryption (pgsodium) for especially sensitive fields like SSN.
  - Session timeout, biometric lock on mobile (`local_auth`), no PHI in logs, certificate pinning.
  - **HIPAA note**: you'll need a BAA with Supabase (available on their Team/Enterprise plans). Plan for this now — it affects pricing and region selection.

---

## 4. Folder Structure (suggested)

```
lib/
  core/            (error, usecase, network, theme, router, di, utils)
  features/
    auth/
    scheduling/
    queue/
    messaging/
    staff/
    inventory/
    ehr/
    analytics/
  main.dart
```

Each feature folder contains `domain/`, `data/`, `presentation/` with standard sub-folders (`entities`, `repositories`, `usecases` / `models`, `datasources`, `repositories` / `cubit`, `pages`, `widgets`).

---

## 5. Key Packages to Add

- `supabase_flutter`, `flutter_bloc`, `get_it`, `go_router`, `dartz`, `equatable`
- `freezed` + `json_serializable` (reduces model boilerplate massively)
- `hive` or `isar` (offline cache)
- `syncfusion_flutter_calendar` + `syncfusion_flutter_charts` (calendar & analytics — paid for commercial, very worth it here)
- `mobile_scanner`, `qr_flutter` (barcode)
- `firebase_messaging` (push), `flutter_local_notifications`
- `local_auth` (biometric lock)
- `intl`, `easy_localization` (i18n — important for Arabic/English given your region)
- `mocktail` + `bloc_test` (testing)

---

## 6. Recommended Build Order (Phased Roadmap)

Building all 23 features in one go will stall. Suggested phases:

**Phase 1 — Foundation (3–4 weeks):** Core, auth, tenancy, RLS baseline, DI, routing, theme, i18n, Supabase project setup + BAA, CI/CD.

**Phase 2 — Scheduling MVP (4–6 weeks):** Appointments, calendar views, provider availability, basic reminders (email only first), online booking. Features 1, 6, 8, 7(partial).

**Phase 3 — Queue & Chat (3–4 weeks):** Check-in, digital queue, triage, in-app chat, templates. Features 2, 3, 11, 12.

**Phase 4 — Staff & Advanced Scheduling (3 weeks):** Shifts, time-off, recurrence, waitlist, drag-and-drop. Features 5, 9, 10, 19, 20.

**Phase 5 — Inventory (4–5 weeks):** Products, lots, movements, reorder, expiry, barcode, billing link. Features 4, 14–18.

**Phase 6 — EHR (5–6 weeks):** Patient chart, encounters, SOAP, prescriptions, labs, attachments. Feature 21.

**Phase 7 — Messaging Expansion & Analytics (3 weeks):** SMS/WhatsApp, bulk, follow-ups, dashboard. Features 13, 22.

**Phase 8 — Compliance Hardening (2–3 weeks):** Audit log coverage, pen-test, role matrix review, session policies. Feature 23.

Total realistic estimate: **6–9 months for a small team**, not counting design and QA. Solo: significantly longer — plan accordingly.

---

## 7. Things to Decide Before Coding

1. **Single-clinic vs multi-clinic tenancy** — affects every schema row. Your wording ("clinic and health centers") suggests multi-tenant; lock this in now.
2. **Patient-facing app**: same Flutter codebase with role-based routing, or a separate app? Same codebase is cheaper; separate is cleaner for store listings.
3. **HIPAA vs local (Egypt) regulations** — confirm which compliance regime applies; it affects hosting region and BAA requirements.
4. **SMS/WhatsApp provider** — Twilio is easiest; WhatsApp Business API has approval lead time, start early.
5. **Offline support scope** — full offline EHR is very hard. Recommend: read-only cache for today's schedule + queue, online-only for writes in v1.
6. **Calendar library budget** — Syncfusion is free for small companies (<$1M revenue) but requires a license key; otherwise budget for it or build custom.

---

Want me to go deeper on any specific module next — e.g., the full Supabase schema with RLS policies for scheduling, or the cubit/state breakdown for the queue module?