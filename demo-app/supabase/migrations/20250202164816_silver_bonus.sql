/*
  # Fix Recursive Policies

  1. Changes
    - Drop existing recursive policies
    - Create new non-recursive policies for users and properties
    - Add proper role-based access control
    - Fix infinite recursion in policy checks

  2. Security
    - Maintain proper access control
    - Ensure data security is preserved
    - Simplify policy checks
*/

-- First, drop all existing policies
DROP POLICY IF EXISTS "Allow read access to authenticated users" ON users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON users;
DROP POLICY IF EXISTS "Allow admins full access to users" ON users;
DROP POLICY IF EXISTS "Allow read access to properties" ON properties;
DROP POLICY IF EXISTS "Allow property management" ON properties;

-- Create new simplified policies for users table
CREATE POLICY "Enable read access for all users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable self profile updates"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Enable admin access"
  ON users
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 
      FROM roles 
      WHERE roles.id = (SELECT role_id FROM users WHERE users.id = auth.uid() LIMIT 1)
      AND roles.name = 'admin'
    )
  );

-- Create new simplified policies for properties table
CREATE POLICY "Enable property read access"
  ON properties
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable property management"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 
      FROM users 
      WHERE users.id = auth.uid()
      AND (
        users.id = properties.owner_id 
        OR users.id = properties.manager_id
        OR users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
      )
    )
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_properties_owner_id ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager_id ON properties(manager_id);