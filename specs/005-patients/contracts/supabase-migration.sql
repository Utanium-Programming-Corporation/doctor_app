-- ============================================================
-- Supabase Migration: 005-patients
-- Patient Management
-- Date: 2026-04-12
-- Depends on: 004-clinic-tenancy (clinics, staff_clinic_assignments)
-- ============================================================

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

CREATE TYPE patient_gender AS ENUM ('male', 'female', 'other');

-- Note: blood_type stored as text (values: 'A+', 'A-', 'B+', 'B-',
-- 'AB+', 'AB-', 'O+', 'O-') rather than an enum, because Postgres
-- enums cannot contain '+' or '-' characters without quoting issues.
-- A CHECK constraint enforces valid values.

-- ------------------------------------------------------------
-- 2. HELPER FUNCTION: generate_patient_number
-- Generates the next sequential patient number for a clinic.
-- Format: P-NNNN (e.g., P-0001, P-0002, ...)
-- Called by trigger on INSERT.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION generate_patient_number()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  next_num integer;
BEGIN
  -- Get the highest existing patient number for this clinic
  SELECT COALESCE(
    MAX(
      CAST(
        SUBSTRING(patient_number FROM 'P-(\d+)') AS integer
      )
    ),
    0
  ) + 1
  INTO next_num
  FROM patients
  WHERE clinic_id = NEW.clinic_id;

  -- Format as P-NNNN (zero-padded to 4 digits, extends if > 9999)
  NEW.patient_number := 'P-' || LPAD(next_num::text, 4, '0');

  RETURN NEW;
END;
$$;

-- ------------------------------------------------------------
-- 3. TABLE
-- ------------------------------------------------------------

CREATE TABLE patients (
  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id               uuid NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  patient_number          text NOT NULL,
  first_name              text NOT NULL,
  last_name               text NOT NULL,
  date_of_birth           date NOT NULL,
  gender                  patient_gender,
  phone_number            text NOT NULL,
  email                   text,
  national_id             text,
  blood_type              text CHECK (
                            blood_type IS NULL OR
                            blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
                          ),
  address                 text,
  emergency_contact_name  text,
  emergency_contact_phone text,
  notes                   text,
  is_active               boolean NOT NULL DEFAULT true,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),

  -- Unique patient number per clinic
  UNIQUE (clinic_id, patient_number)
);

-- ------------------------------------------------------------
-- 4. INDEXES
-- ------------------------------------------------------------

-- Primary search: by name within a clinic
CREATE INDEX idx_patients_clinic_name
  ON patients (clinic_id, last_name, first_name)
  WHERE is_active = true;

-- Search by phone within a clinic
CREATE INDEX idx_patients_clinic_phone
  ON patients (clinic_id, phone_number)
  WHERE is_active = true;

-- Search by national_id within a clinic
CREATE INDEX idx_patients_clinic_national_id
  ON patients (clinic_id, national_id)
  WHERE is_active = true AND national_id IS NOT NULL;

-- Pagination: ordered by created_at within a clinic
CREATE INDEX idx_patients_clinic_created
  ON patients (clinic_id, created_at DESC)
  WHERE is_active = true;

-- ------------------------------------------------------------
-- 5. TRIGGERS
-- ------------------------------------------------------------

-- Auto-generate patient_number on INSERT
CREATE TRIGGER trg_patients_generate_number
  BEFORE INSERT ON patients
  FOR EACH ROW
  WHEN (NEW.patient_number IS NULL OR NEW.patient_number = '')
  EXECUTE FUNCTION generate_patient_number();

-- Auto-update updated_at on UPDATE
-- (reuses update_updated_at() from 004-clinic-tenancy migration)
CREATE TRIGGER trg_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ------------------------------------------------------------
-- 6. ROW LEVEL SECURITY
-- ------------------------------------------------------------

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- SELECT: users can read patients for clinics they belong to
CREATE POLICY patients_select ON patients
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = patients.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.is_active = true
    )
  );

-- INSERT: users can create patients for clinics they belong to
CREATE POLICY patients_insert ON patients
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = patients.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.is_active = true
    )
  );

-- UPDATE: users can update patients for clinics they belong to
CREATE POLICY patients_update ON patients
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = patients.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.is_active = true
    )
  );

-- Note: No DELETE policy — patients are soft-deleted (is_active = false)
-- via UPDATE. Hard deletes are not allowed from the client.
