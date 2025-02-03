-- First, drop all existing policies
DROP POLICY IF EXISTS "allow_users_read_own" ON users;
DROP POLICY IF EXISTS "allow_users_update_own" ON users;
DROP POLICY IF EXISTS "allow_admin_read_all" ON users;
DROP POLICY IF EXISTS "allow_admin_update_all" ON users;
DROP POLICY IF EXISTS "allow_logs_read_own" ON user_activity_logs;
DROP POLICY IF EXISTS "enable_read_theme_settings" ON theme_settings;
DROP POLICY IF EXISTS "enable_update_theme_settings" ON theme_settings;

-- Create a secure function to check admin status
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM roles r
    WHERE r.id = (
      SELECT role_id 
      FROM users 
      WHERE id = user_id
      LIMIT 1
    )
    AND r.name = 'admin'
  );
END;
$$;

-- Create new policies for users table
CREATE POLICY "users_select_policy"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "users_update_policy"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid() OR is_admin(auth.uid()));

-- Create new policies for user_activity_logs
CREATE POLICY "logs_select_policy"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR is_admin(auth.uid()));

-- Create new policies for theme_settings
CREATE POLICY "theme_settings_select_policy"
  ON theme_settings
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "theme_settings_update_policy"
  ON theme_settings
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_logs_user_id ON user_activity_logs(user_id);