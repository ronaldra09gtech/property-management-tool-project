-- Drop all existing policies
DROP POLICY IF EXISTS "enable_read_users" ON users;
DROP POLICY IF EXISTS "enable_update_own_user" ON users;
DROP POLICY IF EXISTS "enable_read_own_logs" ON user_activity_logs;

-- Drop any existing triggers
DROP TRIGGER IF EXISTS log_user_changes ON users;
DROP FUNCTION IF EXISTS log_user_activity();

-- Simplify the users table policies to absolute basics
CREATE POLICY "users_select_policy"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "users_update_policy"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

-- Simplify the user_activity_logs table policies
CREATE POLICY "logs_select_policy"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Create a simpler logging function without recursion
CREATE OR REPLACE FUNCTION log_user_activity()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO user_activity_logs (user_id, action)
    VALUES (NEW.id, 'profile_updated');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a new trigger for logging
CREATE TRIGGER log_user_changes
  AFTER UPDATE
  ON users
  FOR EACH ROW
  EXECUTE FUNCTION log_user_activity();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id);
CREATE INDEX IF NOT EXISTS idx_user_activity_logs_user_id ON user_activity_logs(user_id);