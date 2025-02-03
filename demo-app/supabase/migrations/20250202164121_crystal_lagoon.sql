/*
  # Update Properties Schema

  1. Changes
    - Add missing columns to properties table
    - Update foreign key relationships
    - Add new policies

  2. Security
    - Maintain RLS policies
    - Add policies for new relationships
*/

-- Drop existing foreign key constraints if they exist
ALTER TABLE properties 
DROP CONSTRAINT IF EXISTS properties_owner_id_fkey,
DROP CONSTRAINT IF EXISTS properties_manager_id_fkey;

-- Update properties table
ALTER TABLE properties
ADD COLUMN IF NOT EXISTS image_url text,
ADD COLUMN IF NOT EXISTS owner_id uuid REFERENCES users(id),
ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES users(id);

-- Update RLS policies
DROP POLICY IF EXISTS "Properties are viewable by authenticated users" ON properties;
DROP POLICY IF EXISTS "Admins can manage all properties" ON properties;
DROP POLICY IF EXISTS "Owners can manage their properties" ON properties;
DROP POLICY IF EXISTS "Managers can manage assigned properties" ON properties;

-- Create new policies
CREATE POLICY "Properties are viewable by authenticated users"
  ON properties
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage all properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

CREATE POLICY "Owners can manage their properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY "Managers can manage assigned properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (manager_id = auth.uid());

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_properties_owner ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager ON properties(manager_id);