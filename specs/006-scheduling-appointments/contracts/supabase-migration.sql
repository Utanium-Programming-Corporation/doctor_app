-- =============================================================================
-- Migration: 006 Scheduling & Appointments
-- Feature: 006-scheduling-appointments
-- Date: 2026-04-12
--
-- Tables: appointment_types, provider_availability, provider_blocked_dates, appointments
-- Requires: btree_gist extension (for EXCLUDE constraint)
-- =============================================================================

-- Enable btree_gist extension for mixed-type GiST indexes
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- =============================================================================
-- 1. APPOINTMENT TYPES
-- =============================================================================

CREATE TABLE appointment_types (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id       UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes IN (15, 30, 45, 60, 90, 120)),
    color_hex       TEXT NOT NULL DEFAULT '#4A90D9' CHECK (color_hex ~ '^#[0-9A-Fa-f]{6}$'),
    description     TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index: fast lookup by clinic + active status
CREATE INDEX idx_appointment_types_clinic_active
    ON appointment_types(clinic_id, is_active);

-- RLS
ALTER TABLE appointment_types ENABLE ROW LEVEL SECURITY;

-- All authenticated clinic members can read appointment types
CREATE POLICY "appointment_types_select"
    ON appointment_types FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
        )
    );

-- Only clinic admins can insert/update appointment types
CREATE POLICY "appointment_types_insert"
    ON appointment_types FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true AND role = 'clinic_admin'
        )
    );

CREATE POLICY "appointment_types_update"
    ON appointment_types FOR UPDATE
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true AND role = 'clinic_admin'
        )
    );

-- =============================================================================
-- 2. PROVIDER AVAILABILITY
-- =============================================================================

CREATE TABLE provider_availability (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id       UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    provider_id     UUID NOT NULL,  -- references auth.uid() of the provider
    day_of_week     INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL,
    location_id     UUID,           -- optional FK to clinic locations (future)
    is_active       BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT provider_availability_time_check CHECK (start_time < end_time)
);

-- Index: query by provider + day
CREATE INDEX idx_provider_availability_lookup
    ON provider_availability(clinic_id, provider_id, day_of_week, is_active);

-- RLS
ALTER TABLE provider_availability ENABLE ROW LEVEL SECURITY;

-- All clinic members can read availability
CREATE POLICY "provider_availability_select"
    ON provider_availability FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
        )
    );

-- Provider can manage their own availability, admins can manage any
CREATE POLICY "provider_availability_insert"
    ON provider_availability FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND (role = 'clinic_admin' OR user_id = provider_availability.provider_id)
        )
    );

CREATE POLICY "provider_availability_update"
    ON provider_availability FOR UPDATE
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND (role = 'clinic_admin' OR user_id = provider_availability.provider_id)
        )
    );

CREATE POLICY "provider_availability_delete"
    ON provider_availability FOR DELETE
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND (role = 'clinic_admin' OR user_id = provider_availability.provider_id)
        )
    );

-- =============================================================================
-- 3. PROVIDER BLOCKED DATES
-- =============================================================================

CREATE TABLE provider_blocked_dates (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id       UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    provider_id     UUID NOT NULL,  -- references auth.uid() of the provider
    blocked_date    DATE NOT NULL,
    reason          TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Prevent duplicate blocked dates for same provider
    UNIQUE (provider_id, blocked_date)
);

-- Index: lookup by provider + date range
CREATE INDEX idx_blocked_dates_lookup
    ON provider_blocked_dates(clinic_id, provider_id, blocked_date);

-- RLS
ALTER TABLE provider_blocked_dates ENABLE ROW LEVEL SECURITY;

-- All clinic members can read blocked dates
CREATE POLICY "blocked_dates_select"
    ON provider_blocked_dates FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
        )
    );

-- Provider can manage their own blocked dates, admins can manage any
CREATE POLICY "blocked_dates_insert"
    ON provider_blocked_dates FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND (role = 'clinic_admin' OR user_id = provider_blocked_dates.provider_id)
        )
    );

CREATE POLICY "blocked_dates_delete"
    ON provider_blocked_dates FOR DELETE
    USING (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND (role = 'clinic_admin' OR user_id = provider_blocked_dates.provider_id)
        )
    );

-- =============================================================================
-- 4. APPOINTMENTS
-- =============================================================================

CREATE TABLE appointments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id           UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    patient_id          UUID NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    provider_id         UUID NOT NULL,  -- references auth.uid() of the provider
    appointment_type_id UUID NOT NULL REFERENCES appointment_types(id) ON DELETE RESTRICT,
    location_id         UUID,           -- optional FK to clinic locations (future)
    start_time          TIMESTAMPTZ NOT NULL,
    end_time            TIMESTAMPTZ NOT NULL,
    status              TEXT NOT NULL DEFAULT 'scheduled'
                        CHECK (status IN ('scheduled', 'confirmed', 'checked_in', 'in_progress', 'completed', 'cancelled', 'no_show')),
    is_blocking         BOOLEAN NOT NULL DEFAULT true,  -- false for cancelled/no_show (used by EXCLUDE constraint)
    cancel_reason       TEXT,
    notes               TEXT,
    created_by          UUID NOT NULL,  -- auth.uid() of who created the appointment
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT appointments_time_check CHECK (start_time < end_time)
);

-- EXCLUDE constraint: prevent double-booking for the same provider
-- Only applies to "blocking" appointments (not cancelled/no_show)
ALTER TABLE appointments
    ADD CONSTRAINT appointments_no_overlap
    EXCLUDE USING gist (
        provider_id WITH =,
        tstzrange(start_time, end_time) WITH &&
    ) WHERE (is_blocking = true);

-- Primary query index: appointments for a provider on a date
CREATE INDEX idx_appointments_provider_date
    ON appointments(clinic_id, provider_id, start_time);

-- Index for patient appointment history
CREATE INDEX idx_appointments_patient
    ON appointments(clinic_id, patient_id, start_time);

-- Index for status-based queries
CREATE INDEX idx_appointments_status
    ON appointments(clinic_id, status, start_time);

-- Auto-update updated_at on row change
CREATE OR REPLACE FUNCTION update_appointments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_appointments_updated_at
    BEFORE UPDATE ON appointments
    FOR EACH ROW
    EXECUTE FUNCTION update_appointments_updated_at();

-- Auto-set is_blocking to false when status becomes cancelled or no_show
CREATE OR REPLACE FUNCTION update_appointments_is_blocking()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status IN ('cancelled', 'no_show') THEN
        NEW.is_blocking = false;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_appointments_is_blocking
    BEFORE INSERT OR UPDATE ON appointments
    FOR EACH ROW
    EXECUTE FUNCTION update_appointments_is_blocking();

-- RLS
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Doctors see only their own appointments; admins/receptionists see all clinic appointments
CREATE POLICY "appointments_select"
    ON appointments FOR SELECT
    USING (
        clinic_id IN (
            SELECT sa.clinic_id FROM staff_assignments sa
            WHERE sa.user_id = auth.uid() AND sa.is_active = true
              AND (
                  sa.role IN ('clinic_admin', 'receptionist', 'nurse')
                  OR (sa.role = 'doctor' AND appointments.provider_id = auth.uid())
              )
        )
    );

-- Admins, receptionists, and doctors can create appointments
CREATE POLICY "appointments_insert"
    ON appointments FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM staff_assignments
            WHERE user_id = auth.uid() AND is_active = true
              AND role IN ('clinic_admin', 'receptionist', 'doctor')
        )
    );

-- Status updates allowed for admins, receptionists, and the appointment's provider
CREATE POLICY "appointments_update"
    ON appointments FOR UPDATE
    USING (
        clinic_id IN (
            SELECT sa.clinic_id FROM staff_assignments sa
            WHERE sa.user_id = auth.uid() AND sa.is_active = true
              AND (
                  sa.role IN ('clinic_admin', 'receptionist')
                  OR (sa.role = 'doctor' AND appointments.provider_id = auth.uid())
              )
        )
    );
