/*
  # Fix admin user setup

  1. Changes
    - Drop and recreate admin user with proper password hashing
    - Ensure proper role assignment
    - Add necessary policies for authentication

  2. Security
    - Enable RLS for users table
    - Add policies for authenticated users
*/

-- First, ensure the auth schema extensions are enabled
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Recreate the admin user with proper password hashing
DO $$
DECLARE
  v_user_id uuid;
  v_role_id uuid;
BEGIN
  -- Get or create admin role
  IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'admin') THEN
    INSERT INTO roles (name, permissions)
    VALUES ('admin', '{"all": true}')
    RETURNING id INTO v_role_id;
  ELSE
    SELECT id INTO v_role_id FROM roles WHERE name = 'admin';
  END IF;

  -- Remove existing admin user if exists
  DELETE FROM users WHERE id IN (
    SELECT id FROM auth.users WHERE email = 'admin@example.com'
  );
  DELETE FROM auth.users WHERE email = 'admin@example.com';

  -- Create new admin user
  v_user_id := gen_random_uuid();
  
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    role,
    aud
  ) VALUES (
    v_user_id,
    '00000000-0000-0000-0000-000000000000',
    'admin@example.com',
    crypt('Admin123!', gen_salt('bf')),
    now(),
    '{"provider": "email", "providers": ["email"]}',
    '{"name": "System Admin"}',
    now(),
    now(),
    'authenticated',
    'authenticated'
  );

  -- Create user profile
  INSERT INTO users (id, full_name, role_id)
  VALUES (v_user_id, 'System Admin', v_role_id);
END $$;

-- Ensure proper policies are in place
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Allow users to read their own data
CREATE POLICY "Users can read own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Allow users to update their own data
CREATE POLICY "Users can update own data"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Allow admins to read all users
CREATE POLICY "Admins can read all users"
  ON users
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

-- Allow admins to update all users
CREATE POLICY "Admins can update all users"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );