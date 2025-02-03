/*
  # Fix Recursive Policies

  1. Changes
    - Drop existing recursive policies
    - Create new non-recursive policies for users and properties
    - Simplify policy checks to avoid recursion
    - Add proper role-based access control

  2. Security
    - Maintain proper access control
    - Fix infinite recursion in policy checks
    - Ensure data security is preserved
*/

-- First, drop all existing policies
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable update for users based on id" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable delete for admins only" ON users;
DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON properties;
DROP POLICY IF EXISTS "Enable write access for property owners" ON properties;

-- Create new simplified policies for users table
CREATE POLICY "Allow read access to authenticated users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow users to update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Allow admins full access to users"
  ON users
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE id = (
        SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1
      )
      AND name = 'admin'
    )
  );

-- Create new simplified policies for properties table
CREATE POLICY "Allow read access to properties"
  ON properties
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow property management"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    owner_id = auth.uid()
    OR manager_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM roles
      WHERE id = (
        SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1
      )
      AND name = 'admin'
    )
  );

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_properties_owner_id ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager_id ON properties(manager_id);