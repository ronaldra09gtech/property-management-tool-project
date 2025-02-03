-- First, drop all existing policies
DROP POLICY IF EXISTS "email_settings_read" ON email_settings;
DROP POLICY IF EXISTS "email_settings_update" ON email_settings;
DROP POLICY IF EXISTS "theme_settings_read" ON theme_settings;
DROP POLICY IF EXISTS "theme_settings_update" ON theme_settings;
DROP POLICY IF EXISTS "users_read" ON users;
DROP POLICY IF EXISTS "users_update" ON users;

-- Drop materialized view and related objects
DROP TRIGGER IF EXISTS refresh_admin_roles_trigger ON roles;
DROP FUNCTION IF EXISTS refresh_admin_roles();
DROP MATERIALIZED VIEW IF EXISTS admin_roles;

-- Create a cache table for admin role ID
CREATE TABLE IF NOT EXISTS admin_role_cache (
  role_id uuid PRIMARY KEY,
  updated_at timestamptz DEFAULT now()
);

-- Create function to update admin role cache
CREATE OR REPLACE FUNCTION update_admin_role_cache()
RETURNS TRIGGER AS $$
BEGIN
  -- Clear the cache
  DELETE FROM admin_role_cache;
  
  -- Insert the admin role ID
  INSERT INTO admin_role_cache (role_id)
  SELECT id FROM roles WHERE name = 'admin';
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to maintain cache
CREATE TRIGGER update_admin_role_cache_trigger
AFTER INSERT OR UPDATE OR DELETE ON roles
FOR EACH STATEMENT
EXECUTE FUNCTION update_admin_role_cache();

-- Initialize the cache
INSERT INTO admin_role_cache (role_id)
SELECT id FROM roles WHERE name = 'admin'
ON CONFLICT DO NOTHING;

-- Create simplified policies for email_settings
CREATE POLICY "email_settings_select"
  ON email_settings
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

CREATE POLICY "email_settings_update"
  ON email_settings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Create simplified policies for theme_settings
CREATE POLICY "theme_settings_select"
  ON theme_settings
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "theme_settings_update"
  ON theme_settings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Create simplified policies for users
CREATE POLICY "users_select"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "users_update"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_admin_role_cache_role_id ON admin_role_cache(role_id);