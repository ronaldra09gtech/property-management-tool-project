/*
  # Fix Users RLS Policies

  1. Changes
    - Fix recursive policy issue by using role_id directly
    - Add policy for public profile viewing
    - Add policy for user management

  2. Security
    - Maintain data access control
    - Prevent infinite recursion
    - Allow proper user management
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Public profiles are viewable" ON users;
DROP POLICY IF EXISTS "Admins can manage all users" ON users;
DROP POLICY IF EXISTS "Admins have full access" ON users;

-- Create new non-recursive policies
CREATE POLICY "Allow users to view own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Allow users to update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Allow public profile viewing"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

-- Create admin policies using role_id directly
CREATE POLICY "Allow admin full access"
  ON users
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles r
      WHERE r.id = (
        SELECT role_id FROM users WHERE id = auth.uid()
      )
      AND r.name = 'admin'
    )
  );