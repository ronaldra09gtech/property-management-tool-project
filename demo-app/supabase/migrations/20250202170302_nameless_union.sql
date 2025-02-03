-- First, drop all existing policies on users table
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable self profile updates" ON users;
DROP POLICY IF EXISTS "Enable admin access" ON users;
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable update for users based on id" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable delete for admins only" ON users;
DROP POLICY IF EXISTS "Allow read access to authenticated users" ON users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON users;
DROP POLICY IF EXISTS "Allow public profile viewing" ON users;
DROP POLICY IF EXISTS "Allow admin full access" ON users;

-- Create new simplified policies without recursion
CREATE POLICY "Enable read access for own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Enable update for own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Enable admin full access"
  ON users
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (
        SELECT role_id FROM users WHERE users.id = auth.uid() LIMIT 1
      )
      AND roles.name = 'admin'
    )
  );

-- Update user_activity_logs policies
DROP POLICY IF EXISTS "Users can view their own logs" ON user_activity_logs;
DROP POLICY IF EXISTS "Admins can view all logs" ON user_activity_logs;

CREATE POLICY "Enable viewing own logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Enable admin access to all logs"
  ON user_activity_logs
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles
      WHERE roles.id = (
        SELECT role_id FROM users WHERE users.id = auth.uid() LIMIT 1
      )
      AND roles.name = 'admin'
    )
  );