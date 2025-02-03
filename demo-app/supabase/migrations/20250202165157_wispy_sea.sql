/*
  # Update Properties RLS Policies

  1. Changes
    - Add new RLS policies for properties table to allow system admin and admin users to view all properties
    - Simplify existing policies for better performance and clarity

  2. Security
    - System admin and admin users can view and manage all properties
    - Property owners can manage their own properties
    - Property managers can manage their assigned properties
    - All authenticated users can view properties
*/

-- First, drop existing policies
DROP POLICY IF EXISTS "Allow read access to properties" ON properties;
DROP POLICY IF EXISTS "Allow property management" ON properties;

-- Create new policies
CREATE POLICY "Allow read access to properties"
  ON properties
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow admin full access"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 
      FROM users u
      JOIN roles r ON u.role_id = r.id
      WHERE u.id = auth.uid() 
      AND r.name = 'admin'
    )
  );

CREATE POLICY "Allow owner access"
  ON properties
  FOR ALL
  TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY "Allow manager access"
  ON properties
  FOR ALL
  TO authenticated
  USING (manager_id = auth.uid());

-- Create or replace the function to check admin status
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM users u
    JOIN roles r ON u.role_id = r.id
    WHERE u.id = user_id 
    AND r.name = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;