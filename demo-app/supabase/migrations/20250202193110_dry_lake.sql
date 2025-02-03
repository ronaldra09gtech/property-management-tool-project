-- First, drop all existing policies
DROP POLICY IF EXISTS "email_settings_select" ON email_settings;
DROP POLICY IF EXISTS "email_settings_update" ON email_settings;
DROP POLICY IF EXISTS "theme_settings_select" ON theme_settings;
DROP POLICY IF EXISTS "theme_settings_update" ON theme_settings;
DROP POLICY IF EXISTS "users_select" ON users;
DROP POLICY IF EXISTS "users_update" ON users;

-- Drop existing cache table and related objects
DROP TRIGGER IF EXISTS update_admin_role_cache_trigger ON roles;
DROP FUNCTION IF EXISTS update_admin_role_cache();
DROP TABLE IF EXISTS admin_role_cache;

-- Create a secure function to check admin status without recursion
CREATE OR REPLACE FUNCTION check_admin_access()
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  v_role_name text;
BEGIN
  SELECT r.name INTO v_role_name
  FROM roles r
  JOIN users u ON u.role_id = r.id
  WHERE u.id = auth.uid()
  LIMIT 1;
  
  RETURN v_role_name = 'admin';
END;
$$;

-- Create basic policies for email_settings
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (check_admin_access());

-- Create basic policies for theme_settings
CREATE POLICY "theme_settings_read"
  ON theme_settings
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "theme_settings_write"
  ON theme_settings
  FOR ALL
  TO authenticated
  USING (check_admin_access());

-- Create basic policies for users
CREATE POLICY "users_read"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "users_write"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    id = auth.uid() OR check_admin_access()
  );

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION check_admin_access TO authenticated;
GRANT EXECUTE ON FUNCTION check_admin_access TO anon;