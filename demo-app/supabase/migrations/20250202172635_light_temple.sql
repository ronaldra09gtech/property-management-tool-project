-- Drop all existing policies and triggers
DROP POLICY IF EXISTS "users_select_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;
DROP POLICY IF EXISTS "logs_select_policy" ON user_activity_logs;
DROP TRIGGER IF EXISTS log_user_changes ON users;
DROP FUNCTION IF EXISTS log_user_activity();

-- Create the absolute simplest policies possible
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Simple read-only policy for users
CREATE POLICY "users_read_policy" ON users
FOR SELECT TO authenticated
USING (true);

-- Simple update policy for users
CREATE POLICY "users_write_policy" ON users
FOR UPDATE TO authenticated
USING (auth.uid() = id);

-- Simple read policy for logs
CREATE POLICY "logs_read_policy" ON user_activity_logs
FOR SELECT TO authenticated
USING (user_id = auth.uid());

-- Create a very simple logging function
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

-- Create trigger
CREATE TRIGGER user_activity_trigger
AFTER UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION log_user_activity();