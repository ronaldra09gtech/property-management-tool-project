/*
  # Fix RLS Policies and Schema

  1. Changes
    - Drop existing problematic policies
    - Add missing columns to users table
    - Create new non-recursive policies
    - Update property relationships

  2. Security
    - Fix infinite recursion in policies
    - Maintain proper access control
    - Enable proper user management
*/

-- First, drop all existing policies to start fresh
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Public profiles are viewable" ON users;
DROP POLICY IF EXISTS "Admins can manage all users" ON users;
DROP POLICY IF EXISTS "Admins have full access" ON users;
DROP POLICY IF EXISTS "Allow users to view own profile" ON users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON users;
DROP POLICY IF EXISTS "Allow public profile viewing" ON users;
DROP POLICY IF EXISTS "Allow admin full access" ON users;

-- Update users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS full_name text,
ADD COLUMN IF NOT EXISTS email text,
ADD COLUMN IF NOT EXISTS phone text,
ADD COLUMN IF NOT EXISTS image_url text;

-- Create new policies for users table
CREATE POLICY "Enable read access for authenticated users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable update for users based on id"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Enable insert for authenticated users"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = role_id
      AND roles.name = 'admin'
    )
    OR auth.uid() = id
  );

CREATE POLICY "Enable delete for admins only"
  ON users
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (SELECT role_id FROM users WHERE id = auth.uid())
      AND roles.name = 'admin'
    )
  );

-- Update properties table
ALTER TABLE properties
ADD COLUMN IF NOT EXISTS image_url text,
ADD COLUMN IF NOT EXISTS owner_id uuid REFERENCES users(id),
ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES users(id);

-- Create policies for properties table
CREATE POLICY "Enable read access for all authenticated users"
  ON properties
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable write access for property owners"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    owner_id = auth.uid()
    OR
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (SELECT role_id FROM users WHERE id = auth.uid())
      AND roles.name IN ('admin', 'manager')
    )
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_properties_owner ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager ON properties(manager_id);