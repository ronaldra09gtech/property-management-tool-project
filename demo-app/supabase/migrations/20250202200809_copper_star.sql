-- Drop existing policies
DROP POLICY IF EXISTS "departments_read_policy" ON departments;
DROP POLICY IF EXISTS "departments_insert_policy" ON departments;
DROP POLICY IF EXISTS "departments_update_policy" ON departments;
DROP POLICY IF EXISTS "departments_delete_policy" ON departments;
DROP POLICY IF EXISTS "users_select" ON users;
DROP POLICY IF EXISTS "users_update" ON users;

-- Create a materialized view for admin roles to avoid recursion
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_roles AS
SELECT id FROM roles WHERE name = 'admin';

-- Create index on the materialized view
CREATE UNIQUE INDEX IF NOT EXISTS admin_roles_id_idx ON admin_roles(id);

-- Create trigger function to refresh materialized view
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

-- Create simplified policies for users table
CREATE POLICY "users_read_policy"
  ON users
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "users_update_policy"
  ON users
  FOR UPDATE
  TO authenticated
  USING (
    id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM admin_roles
      WHERE id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Create simplified policies for departments table
CREATE POLICY "departments_read_policy"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "departments_insert_policy"
  ON departments
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_roles
      WHERE id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

CREATE POLICY "departments_update_policy"
  ON departments
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_roles
      WHERE id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

CREATE POLICY "departments_delete_policy"
  ON departments
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_roles
      WHERE id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Initial refresh of the materialized view
REFRESH MATERIALIZED VIEW admin_roles;

-- Grant necessary permissions
GRANT ALL ON departments TO authenticated;