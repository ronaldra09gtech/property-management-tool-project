-- Drop all existing policies
DROP POLICY IF EXISTS "allow_select_own_user" ON users;
DROP POLICY IF EXISTS "allow_update_own_user" ON users;
DROP POLICY IF EXISTS "allow_admin_select_users" ON users;
DROP POLICY IF EXISTS "allow_admin_update_users" ON users;
DROP POLICY IF EXISTS "allow_select_own_logs" ON user_activity_logs;
DROP POLICY IF EXISTS "allow_admin_select_logs" ON user_activity_logs;

-- Create a materialized view for admin users to avoid recursion
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_users AS
SELECT users.id
FROM users
JOIN roles ON users.role_id = roles.id
WHERE roles.name = 'admin';

-- Create index on the materialized view
CREATE UNIQUE INDEX IF NOT EXISTS admin_users_id_idx ON admin_users(id);

-- Create function to refresh materialized view
CREATE OR REPLACE FUNCTION refresh_admin_users()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY admin_users;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to refresh the view
DROP TRIGGER IF EXISTS refresh_admin_users_trigger ON users;
CREATE TRIGGER refresh_admin_users_trigger
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_admin_users();

-- Create basic policies for users table
CREATE POLICY "allow_read_own_user"
  ON users
  FOR SELECT
  TO authenticated
  USING (
    id = auth.uid() OR 
    EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid())
  );

CREATE POLICY "allow_update_own_user"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    id = auth.uid() OR 
    EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid())
  );

-- Create basic policies for user_activity_logs table
CREATE POLICY "allow_read_own_logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR 
    EXISTS (SELECT 1 FROM admin_users WHERE id = auth.uid())
  );

-- Initial refresh of the materialized view
REFRESH MATERIALIZED VIEW admin_users;