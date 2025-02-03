-- Drop all existing policies
DROP POLICY IF EXISTS "allow_read_own_user" ON users;
DROP POLICY IF EXISTS "allow_update_own_user" ON users;
DROP POLICY IF EXISTS "allow_read_own_logs" ON user_activity_logs;

-- Drop materialized view and related objects
DROP TRIGGER IF EXISTS refresh_admin_users_trigger ON users;
DROP FUNCTION IF EXISTS refresh_admin_users();
DROP MATERIALIZED VIEW IF EXISTS admin_users;

-- Create simple policies for users table
CREATE POLICY "enable_read_users"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "enable_update_own_user"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

-- Create simple policy for user_activity_logs
CREATE POLICY "enable_read_own_logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_logs_user_id ON user_activity_logs(user_id);