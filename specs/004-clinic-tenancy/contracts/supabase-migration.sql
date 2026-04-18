-- ============================================================
-- Supabase Migration: 004-clinic-tenancy
-- Clinic & Multi-Tenant Setup
-- Date: 2026-04-12
-- ============================================================

-- ------------------------------------------------------------
-- 1. ENUM TYPES
-- ------------------------------------------------------------

CREATE TYPE clinic_type AS ENUM (
  'general_practice',
  'dental',
  'dermatology',
  'pediatrics',
  'orthopedics',
  'ophthalmology',
  'cardiology',
  'multi_specialty',
  'other'
);

CREATE TYPE staff_role_type AS ENUM (
  'clinic_admin',
  'doctor',
  'receptionist',
  'nurse',
  'other'
);

-- ------------------------------------------------------------
-- 2. HELPER FUNCTION: generate_invite_code
-- Generates a unique 8-character uppercase alphanumeric code.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION generate_invite_code()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  chars text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  result text;
  i integer;
  attempts integer := 0;
BEGIN
  LOOP
    result := '';
    FOR i IN 1..8 LOOP
      result := result || substr(chars, floor(random() * length(chars) + 1)::integer, 1);
    END LOOP;

    -- Check uniqueness
    IF NOT EXISTS (SELECT 1 FROM clinics WHERE invite_code = result) THEN
      RETURN result;
    END IF;

    attempts := attempts + 1;
    IF attempts >= 10 THEN
      RAISE EXCEPTION 'Could not generate unique invite code after 10 attempts';
    END IF;
  END LOOP;
END;
$$;

-- ------------------------------------------------------------
-- 3. TABLES
-- ------------------------------------------------------------

-- clinics
CREATE TABLE clinics (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  phone       text NOT NULL,
  address     text NOT NULL,
  type        clinic_type NOT NULL DEFAULT 'general_practice',
  invite_code text NOT NULL UNIQUE DEFAULT generate_invite_code(),
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_clinics_invite_code ON clinics (invite_code) WHERE is_active = true;

-- staff_clinic_assignments
CREATE TABLE staff_clinic_assignments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  clinic_id   uuid NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  role        staff_role_type NOT NULL DEFAULT 'doctor',
  is_active   boolean NOT NULL DEFAULT true,
  joined_at   timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, clinic_id)
);

CREATE INDEX idx_sca_user_id ON staff_clinic_assignments (user_id) WHERE is_active = true;
CREATE INDEX idx_sca_clinic_id ON staff_clinic_assignments (clinic_id) WHERE is_active = true;

-- locations
CREATE TABLE locations (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id   uuid NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  name        text NOT NULL DEFAULT 'Main',
  address     text NOT NULL,
  phone       text NOT NULL,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_locations_clinic_id ON locations (clinic_id) WHERE is_active = true;

-- ------------------------------------------------------------
-- 4. UPDATED_AT TRIGGERS
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_clinics_updated_at
  BEFORE UPDATE ON clinics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_sca_updated_at
  BEFORE UPDATE ON staff_clinic_assignments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_locations_updated_at
  BEFORE UPDATE ON locations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ------------------------------------------------------------
-- 5. ROW LEVEL SECURITY
-- ------------------------------------------------------------

ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_clinic_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;

-- clinics: users can SELECT clinics they belong to
CREATE POLICY clinics_select ON clinics
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = clinics.id
        AND sca.user_id = auth.uid()
        AND sca.is_active = true
    )
  );

-- clinics: allow reading by invite_code for authenticated users (for join flow)
CREATE POLICY clinics_select_by_invite ON clinics
  FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND is_active = true
  );

-- clinics: INSERT allowed for authenticated users (create clinic)
CREATE POLICY clinics_insert ON clinics
  FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

-- clinics: UPDATE only by clinic_admin
CREATE POLICY clinics_update ON clinics
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = clinics.id
        AND sca.user_id = auth.uid()
        AND sca.role = 'clinic_admin'
        AND sca.is_active = true
    )
  );

-- staff_clinic_assignments: users can see assignments for their clinics
CREATE POLICY sca_select ON staff_clinic_assignments
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments my_sca
      WHERE my_sca.clinic_id = staff_clinic_assignments.clinic_id
        AND my_sca.user_id = auth.uid()
        AND my_sca.is_active = true
    )
  );

-- staff_clinic_assignments: INSERT allowed for joining (own user_id) or clinic_admin
CREATE POLICY sca_insert ON staff_clinic_assignments
  FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM staff_clinic_assignments admin_sca
      WHERE admin_sca.clinic_id = staff_clinic_assignments.clinic_id
        AND admin_sca.user_id = auth.uid()
        AND admin_sca.role = 'clinic_admin'
        AND admin_sca.is_active = true
    )
  );

-- staff_clinic_assignments: UPDATE only by clinic_admin of that clinic
CREATE POLICY sca_update ON staff_clinic_assignments
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments admin_sca
      WHERE admin_sca.clinic_id = staff_clinic_assignments.clinic_id
        AND admin_sca.user_id = auth.uid()
        AND admin_sca.role = 'clinic_admin'
        AND admin_sca.is_active = true
    )
  );

-- locations: users can see locations for their clinics
CREATE POLICY locations_select ON locations
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = locations.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.is_active = true
    )
  );

-- locations: INSERT by clinic_admin
CREATE POLICY locations_insert ON locations
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = locations.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.role = 'clinic_admin'
        AND sca.is_active = true
    )
  );

-- locations: UPDATE by clinic_admin
CREATE POLICY locations_update ON locations
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM staff_clinic_assignments sca
      WHERE sca.clinic_id = locations.clinic_id
        AND sca.user_id = auth.uid()
        AND sca.role = 'clinic_admin'
        AND sca.is_active = true
    )
  );

-- ------------------------------------------------------------
-- 6. RPC FUNCTIONS
-- ------------------------------------------------------------

-- create_clinic_with_defaults: Atomic clinic creation with admin + default location
CREATE OR REPLACE FUNCTION create_clinic_with_defaults(
  p_name text,
  p_phone text,
  p_address text,
  p_type clinic_type
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_clinic_id uuid;
  v_invite_code text;
  v_clinic json;
BEGIN
  -- Generate invite code
  v_invite_code := generate_invite_code();

  -- Insert clinic
  INSERT INTO clinics (name, phone, address, type, invite_code)
  VALUES (p_name, p_phone, p_address, p_type, v_invite_code)
  RETURNING id INTO v_clinic_id;

  -- Assign creator as clinic_admin
  INSERT INTO staff_clinic_assignments (user_id, clinic_id, role)
  VALUES (auth.uid(), v_clinic_id, 'clinic_admin');

  -- Create default location
  INSERT INTO locations (clinic_id, name, address, phone)
  VALUES (v_clinic_id, 'Main', p_address, p_phone);

  -- Return full clinic row as JSON
  SELECT row_to_json(c) INTO v_clinic
  FROM clinics c WHERE c.id = v_clinic_id;

  RETURN v_clinic;
END;
$$;

-- regenerate_clinic_invite_code: Atomically replace invite code
CREATE OR REPLACE FUNCTION regenerate_clinic_invite_code(p_clinic_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_new_code text;
  v_clinic json;
BEGIN
  -- Verify caller is clinic_admin
  IF NOT EXISTS (
    SELECT 1 FROM staff_clinic_assignments
    WHERE clinic_id = p_clinic_id
      AND user_id = auth.uid()
      AND role = 'clinic_admin'
      AND is_active = true
  ) THEN
    RAISE EXCEPTION 'Only clinic admins can regenerate invite codes';
  END IF;

  v_new_code := generate_invite_code();

  UPDATE clinics SET invite_code = v_new_code
  WHERE id = p_clinic_id;

  SELECT row_to_json(c) INTO v_clinic
  FROM clinics c WHERE c.id = p_clinic_id;

  RETURN v_clinic;
END;
$$;

-- deactivate_staff_member: Prevents deactivation of last admin
CREATE OR REPLACE FUNCTION deactivate_staff_member(p_assignment_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_clinic_id uuid;
  v_target_user_id uuid;
  v_target_role staff_role_type;
  v_admin_count integer;
BEGIN
  -- Get the assignment details
  SELECT clinic_id, user_id, role INTO v_clinic_id, v_target_user_id, v_target_role
  FROM staff_clinic_assignments
  WHERE id = p_assignment_id AND is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Assignment not found or already inactive';
  END IF;

  -- Verify caller is clinic_admin of this clinic
  IF NOT EXISTS (
    SELECT 1 FROM staff_clinic_assignments
    WHERE clinic_id = v_clinic_id
      AND user_id = auth.uid()
      AND role = 'clinic_admin'
      AND is_active = true
  ) THEN
    RAISE EXCEPTION 'Only clinic admins can deactivate staff';
  END IF;

  -- Prevent self-deactivation
  IF v_target_user_id = auth.uid() THEN
    RAISE EXCEPTION 'Cannot deactivate your own account';
  END IF;

  -- If target is admin, check we're not removing the last admin
  IF v_target_role = 'clinic_admin' THEN
    SELECT COUNT(*) INTO v_admin_count
    FROM staff_clinic_assignments
    WHERE clinic_id = v_clinic_id
      AND role = 'clinic_admin'
      AND is_active = true;

    IF v_admin_count <= 1 THEN
      RAISE EXCEPTION 'Cannot deactivate the last clinic admin';
    END IF;
  END IF;

  -- Deactivate
  UPDATE staff_clinic_assignments
  SET is_active = false
  WHERE id = p_assignment_id;
END;
$$;
