-- Drop all existing policies
DROP POLICY IF EXISTS "users_read_policy" ON users;
DROP POLICY IF EXISTS "users_write_policy" ON users;
DROP POLICY IF EXISTS "logs_read_policy" ON user_activity_logs;
DROP TRIGGER IF EXISTS user_activity_trigger ON users;
DROP FUNCTION IF EXISTS log_user_activity();

-- Create a function to check if a user is an admin
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  role_name text;
BEGIN
  SELECT r.name INTO role_name
  FROM roles r
  JOIN users u ON u.role_id = r.id
  WHERE u.id = user_id
  LIMIT 1;
  
  RETURN role_name = 'admin';
END;
$$;

-- Create basic policies for users table
CREATE POLICY "allow_users_read_own"
  ON users
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "allow_users_update_own"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "allow_admin_read_all"
  ON users
  FOR SELECT
  TO authenticated
  USING (
    is_admin(auth.uid())
  );

CREATE POLICY "allow_admin_update_all"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    is_admin(auth.uid())
  );

-- Create basic policies for user_activity_logs
CREATE POLICY "allow_logs_read_own"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    is_admin(auth.uid())
  );

-- Create a simple logging function
CREATE OR REPLACE FUNCTION log_user_activity()
RETURNS trigger
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    INSERT INTO user_activity_logs (user_id, action)
    VALUES (NEW.id, 'profile_updated');
  END IF;
  RETURN NEW;
END;
$$;

-- Create trigger for logging
CREATE TRIGGER log_user_activity_trigger
  AFTER UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION log_user_activity();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id);
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_logs_user_id ON user_activity_logs(user_id);