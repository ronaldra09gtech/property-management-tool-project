-- Drop all existing policies
DROP POLICY IF EXISTS "Enable read access for own profile" ON users;
DROP POLICY IF EXISTS "Enable update for own profile" ON users;
DROP POLICY IF EXISTS "Enable admin full access" ON users;
DROP POLICY IF EXISTS "Enable viewing own logs" ON user_activity_logs;
DROP POLICY IF EXISTS "Enable admin access to all logs" ON user_activity_logs;
DROP POLICY IF EXISTS "users_read_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;
DROP POLICY IF EXISTS "logs_read_policy" ON user_activity_logs;

-- Create basic policies for users table
CREATE POLICY "allow_select_own_user"
  ON users
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "allow_update_own_user"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

-- Create basic policy for user_activity_logs
CREATE POLICY "allow_select_own_logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Create separate admin policies
CREATE POLICY "allow_admin_select_users"
  ON users
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1)
      AND roles.name = 'admin'
    )
  );

CREATE POLICY "allow_admin_update_users"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1)
      AND roles.name = 'admin'
    )
  );

CREATE POLICY "allow_admin_select_logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1)
      AND roles.name = 'admin'
    )
  );