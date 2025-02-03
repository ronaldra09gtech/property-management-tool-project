/*
  # Property Management Schema Update

  1. New Tables
    - `property_owners` - Stores property owner information
    - `property_managers` - Stores property manager information
    - `properties` - Stores property information with relations to owners and managers

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
    - Add policies for specific roles (admin, manager, owner)

  3. Changes
    - Added foreign key relationships between properties and users
    - Added audit timestamps for all tables
*/

-- Create property_owners table
CREATE TABLE IF NOT EXISTS property_owners (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  company_name text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create property_managers table
CREATE TABLE IF NOT EXISTS property_managers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  department text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create properties table
CREATE TABLE IF NOT EXISTS properties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  address text NOT NULL,
  description text,
  units integer NOT NULL DEFAULT 0,
  occupancy_rate numeric DEFAULT 0,
  revenue numeric DEFAULT 0,
  amenities jsonb DEFAULT '[]',
  images text[] DEFAULT '{}',
  status text NOT NULL DEFAULT 'active',
  owner_id uuid REFERENCES property_owners(id),
  manager_id uuid REFERENCES property_managers(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE property_owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE property_managers ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

-- Create policies for property_owners
CREATE POLICY "Owners can view own data"
  ON property_owners
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all owners"
  ON property_owners
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

-- Create policies for property_managers
CREATE POLICY "Managers can view own data"
  ON property_managers
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all managers"
  ON property_managers
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

-- Create policies for properties
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
  USING (
    EXISTS (
      SELECT 1 FROM property_owners
      WHERE property_owners.id = properties.owner_id
      AND property_owners.user_id = auth.uid()
    )
  );

CREATE POLICY "Managers can manage assigned properties"
  ON properties
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM property_managers
      WHERE property_managers.id = properties.manager_id
      AND property_managers.user_id = auth.uid()
    )
  );

-- Create indexes for better performance
CREATE INDEX idx_properties_owner ON properties(owner_id);
CREATE INDEX idx_properties_manager ON properties(manager_id);
CREATE INDEX idx_property_owners_user ON property_owners(user_id);
CREATE INDEX idx_property_managers_user ON property_managers(user_id);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updating timestamps
CREATE TRIGGER update_property_owners_updated_at
  BEFORE UPDATE ON property_owners
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_property_managers_updated_at
  BEFORE UPDATE ON property_managers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();