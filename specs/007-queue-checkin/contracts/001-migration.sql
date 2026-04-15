-- Migration: 007-queue-checkin
-- Description: Queue tokens, triage assessments, token auto-increment function, check-in RPC, RLS
-- Date: 2026-04-12

-- ============================================================
-- 1. Tables
-- ============================================================

CREATE TABLE queue_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  location_id UUID REFERENCES locations(id),
  token_number INTEGER NOT NULL,
  patient_id UUID NOT NULL REFERENCES patients(id),
  appointment_id UUID REFERENCES appointments(id),
  provider_id UUID NOT NULL REFERENCES profiles(id),
  status TEXT NOT NULL DEFAULT 'waiting'
    CHECK (status IN ('waiting','called','in_progress','completed','no_show','skipped')),
  priority TEXT NOT NULL DEFAULT 'normal'
    CHECK (priority IN ('normal','urgent')),
  skip_count INTEGER NOT NULL DEFAULT 0,
  called_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Partial unique index: prevent duplicate check-in per appointment
CREATE UNIQUE INDEX uq_queue_tokens_appointment
  ON queue_tokens (appointment_id)
  WHERE appointment_id IS NOT NULL;

CREATE INDEX idx_queue_tokens_clinic_date
  ON queue_tokens (clinic_id, (created_at::date));

CREATE INDEX idx_queue_tokens_provider_status
  ON queue_tokens (provider_id, status);

CREATE INDEX idx_queue_tokens_clinic_status
  ON queue_tokens (clinic_id, status);

CREATE TABLE triage_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_token_id UUID NOT NULL UNIQUE REFERENCES queue_tokens(id) ON DELETE CASCADE,
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  blood_pressure_systolic INTEGER,
  blood_pressure_diastolic INTEGER,
  heart_rate INTEGER,
  temperature NUMERIC(4,1),
  weight NUMERIC(5,1),
  spo2 INTEGER,
  chief_complaint TEXT,
  recorded_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_triage_queue_token
  ON triage_assessments (queue_token_id);

-- ============================================================
-- 2. Functions
-- ============================================================

-- Auto-increment token number per clinic per day (atomic)
CREATE OR REPLACE FUNCTION generate_queue_token_number(p_clinic_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  next_number INTEGER;
BEGIN
  -- Lock existing rows for this clinic today to serialize concurrent inserts
  PERFORM 1 FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND created_at::date = CURRENT_DATE
  FOR UPDATE;

  SELECT COALESCE(MAX(token_number), 0) + 1
  INTO next_number
  FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND created_at::date = CURRENT_DATE;

  RETURN next_number;
END;
$$;

-- Check-in RPC: creates token + updates appointment status atomically
CREATE OR REPLACE FUNCTION check_in_patient(
  p_clinic_id UUID,
  p_patient_id UUID,
  p_appointment_id UUID,
  p_provider_id UUID,
  p_priority TEXT DEFAULT 'normal',
  p_location_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_token_number INTEGER;
  v_token_id UUID;
BEGIN
  -- Guard: prevent duplicate check-in
  IF p_appointment_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM queue_tokens WHERE appointment_id = p_appointment_id
    ) THEN
      RAISE EXCEPTION 'Appointment % already checked in', p_appointment_id;
    END IF;
  END IF;

  -- Generate daily token number (atomic)
  v_token_number := generate_queue_token_number(p_clinic_id);

  -- Insert queue token
  INSERT INTO queue_tokens (
    clinic_id, location_id, token_number, patient_id,
    appointment_id, provider_id, status, priority
  ) VALUES (
    p_clinic_id, p_location_id, v_token_number, p_patient_id,
    p_appointment_id, p_provider_id, 'waiting', p_priority
  )
  RETURNING id INTO v_token_id;

  -- Transition appointment to checked_in
  IF p_appointment_id IS NOT NULL THEN
    UPDATE appointments
    SET status = 'checked_in', updated_at = now()
    WHERE id = p_appointment_id
      AND status IN ('scheduled', 'confirmed');
  END IF;

  RETURN jsonb_build_object(
    'token_id', v_token_id,
    'token_number', v_token_number
  );
END;
$$;

-- Call next: atomically pick highest-priority waiting token for a provider
CREATE OR REPLACE FUNCTION call_next_patient(
  p_clinic_id UUID,
  p_provider_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_token_id UUID;
BEGIN
  SELECT id INTO v_token_id
  FROM queue_tokens
  WHERE clinic_id = p_clinic_id
    AND provider_id = p_provider_id
    AND status = 'waiting'
    AND created_at::date = CURRENT_DATE
  ORDER BY
    CASE priority WHEN 'urgent' THEN 0 ELSE 1 END,
    skip_count ASC,
    created_at ASC
  LIMIT 1
  FOR UPDATE SKIP LOCKED;

  IF v_token_id IS NULL THEN
    RETURN NULL;
  END IF;

  UPDATE queue_tokens
  SET status = 'called', called_at = now()
  WHERE id = v_token_id;

  RETURN v_token_id;
END;
$$;

-- ============================================================
-- 3. Row Level Security
-- ============================================================

ALTER TABLE queue_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "queue_tokens_select"
  ON queue_tokens FOR SELECT
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "queue_tokens_insert"
  ON queue_tokens FOR INSERT
  WITH CHECK (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "queue_tokens_update"
  ON queue_tokens FOR UPDATE
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

ALTER TABLE triage_assessments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "triage_select"
  ON triage_assessments FOR SELECT
  USING (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

CREATE POLICY "triage_insert"
  ON triage_assessments FOR INSERT
  WITH CHECK (clinic_id IN (
    SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
  ));

-- ============================================================
-- 4. Realtime
-- ============================================================

ALTER PUBLICATION supabase_realtime ADD TABLE queue_tokens;
