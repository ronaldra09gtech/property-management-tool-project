-- Drop existing policies that might cause recursion
DROP POLICY IF EXISTS "enable_read_email_settings" ON email_settings;
DROP POLICY IF EXISTS "enable_update_email_settings" ON email_settings;
DROP POLICY IF EXISTS "theme_settings_select_policy" ON theme_settings;
DROP POLICY IF EXISTS "theme_settings_update_policy" ON theme_settings;
DROP POLICY IF EXISTS "users_select_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;

-- Create a materialized view for admin roles to avoid recursion
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_roles AS
SELECT id FROM roles WHERE name = 'admin';

-- Create index on the materialized view
CREATE UNIQUE INDEX IF NOT EXISTS admin_roles_id_idx ON admin_roles(id);

-- Create function to refresh materialized view
CREATE OR REPLACE FUNCTION refresh_admin_roles()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY admin_roles;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to refresh the view
CREATE TRIGGER refresh_admin_roles_trigger
AFTER INSERT OR UPDATE OR DELETE ON roles
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_admin_roles();

-- Create simplified policies for email_settings
CREATE POLICY "email_settings_read"
  ON email_settings
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM admin_roles)
    )
  );

CREATE POLICY "email_settings_update"
  ON email_settings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM admin_roles)
    )
  );

-- Create simplified policies for theme_settings
CREATE POLICY "theme_settings_read"
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
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM admin_roles)
    )
  );

-- Create simplified policies for users
CREATE POLICY "users_read"
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
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.role_id IN (SELECT id FROM admin_roles)
    )
  );

-- Initial refresh of the materialized view
REFRESH MATERIALIZED VIEW admin_roles;