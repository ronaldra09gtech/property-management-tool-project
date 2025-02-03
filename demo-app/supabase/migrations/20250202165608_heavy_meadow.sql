/*
  # Fix Properties Schema

  1. Changes
    - Update properties table structure
    - Add missing columns
    - Set up proper foreign key relationships
    - Create simplified RLS policies

  2. Security
    - Enable RLS
    - Add policies for different user roles
*/

-- Update properties table structure
DO $$ 
BEGIN
  -- Add columns if they don't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'image_url') THEN
    ALTER TABLE properties ADD COLUMN image_url text;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'units') THEN
    ALTER TABLE properties ADD COLUMN units integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'occupancy_rate') THEN
    ALTER TABLE properties ADD COLUMN occupancy_rate numeric DEFAULT 0;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'revenue') THEN
    ALTER TABLE properties ADD COLUMN revenue numeric DEFAULT 0;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'owner_id') THEN
    ALTER TABLE properties ADD COLUMN owner_id uuid REFERENCES auth.users(id);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'properties' AND column_name = 'manager_id') THEN
    ALTER TABLE properties ADD COLUMN manager_id uuid REFERENCES auth.users(id);
  END IF;
END $$;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_properties_owner_id ON properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_manager_id ON properties(manager_id);
CREATE INDEX IF NOT EXISTS idx_properties_units ON properties(units);
CREATE INDEX IF NOT EXISTS idx_properties_occupancy_rate ON properties(occupancy_rate);
CREATE INDEX IF NOT EXISTS idx_properties_revenue ON properties(revenue);

-- Drop existing policies if they exist
DO $$ 
BEGIN
  DROP POLICY IF EXISTS "Properties are viewable by authenticated users" ON properties;
  DROP POLICY IF EXISTS "Admins can manage all properties" ON properties;
  DROP POLICY IF EXISTS "Owners can manage their properties" ON properties;
  DROP POLICY IF EXISTS "Managers can manage their properties" ON properties;
EXCEPTION
  WHEN undefined_object THEN
    NULL;
END $$;

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
      SELECT 1 FROM users u
      JOIN roles r ON u.role_id = r.id
      WHERE u.id = auth.uid()
      AND r.name = 'admin'
    )
  );

CREATE POLICY "Owners can manage their properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY "Managers can manage their properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (manager_id = auth.uid());