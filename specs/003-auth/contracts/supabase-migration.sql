-- Migration: 003-auth — profiles table with RLS
-- Feature: Authentication & User Onboarding
-- Date: 2026-04-12
--
-- Prerequisites: Supabase project with Auth enabled, Google and Apple providers configured.
-- Run this in the Supabase SQL Editor or via a migration tool.

-- 1. Create the user_role enum type
CREATE TYPE public.user_role AS ENUM (
  'super_admin',
  'clinic_admin',
  'doctor',
  'nurse',
  'receptionist',
  'pharmacist'
);

-- 2. Create profiles table
CREATE TABLE public.profiles (
  id              uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name       text        NOT NULL,
  phone_number    text,
  role            public.user_role NOT NULL DEFAULT 'doctor',
  preferred_language text     NOT NULL DEFAULT 'en'
                              CHECK (preferred_language IN ('en', 'ar')),
  avatar_url      text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- 3. Add comment for documentation
COMMENT ON TABLE public.profiles IS 'User profiles for clinic staff. One row per auth.users entry.';

-- 4. Create updated_at trigger function (reusable across tables)
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5. Attach trigger to profiles table
CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- 6. Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 7. RLS Policies

-- Users can read their own profile
CREATE POLICY "Users can read own profile"
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Users can insert their own profile (on first sign-in)
CREATE POLICY "Users can insert own profile"
  ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- No DELETE policy — profiles are permanent.
-- Admin read-all policy will be added by a future clinic-management feature
-- when clinic_id column is introduced.

-- 8. Create index for faster lookups (PK already indexed, but explicit for clarity)
-- The PK constraint already creates a unique index on id, so no additional index needed.

-- 9. Grant access to authenticated users (Supabase default role)
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
