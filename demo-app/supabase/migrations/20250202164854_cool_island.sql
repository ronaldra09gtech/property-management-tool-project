/*
  # Fix Recursive Policies - Final Version

  1. Changes
    - Drop all existing recursive policies
    - Create new non-recursive policies with proper role checks
    - Simplify policy logic to avoid circular dependencies
    - Add proper indexes for performance

  2. Security
    - Maintain proper access control
    - Ensure data security is preserved
    - Prevent infinite recursion
*/

-- First, drop all existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable self profile updates" ON users;
DROP POLICY IF EXISTS "Enable admin access" ON users;
DROP POLICY IF EXISTS "Enable property read access" ON properties;
DROP POLICY IF EXISTS "Enable property management" ON properties;

-- Create a function to check if a user is an admin
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM roles r
    JOIN users u ON u.role_id = r.id
    WHERE u.id = user_id 
    AND r.name = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create new simplified policies for users table
CREATE POLICY "Allow read access to users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow self updates"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Allow admin full access"
  ON users
  FOR ALL
  TO authenticated
  USING (is_admin(auth.uid()));

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
    OR is_admin(auth.uid())
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_properties_owner_id ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager_id ON properties(manager_id);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION is_admin TO authenticated;
GRANT EXECUTE ON FUNCTION is_admin TO anon;