-- Drop all existing policies
DROP POLICY IF EXISTS "allow_read_departments" ON departments;
DROP POLICY IF EXISTS "allow_manage_departments" ON departments;
DROP POLICY IF EXISTS "dept_select_policy" ON departments;
DROP POLICY IF EXISTS "dept_write_policy" ON departments;

-- Drop existing function
DROP FUNCTION IF EXISTS is_department_admin();

-- Create a materialized view for admin role ID
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_role_id AS
SELECT id FROM roles WHERE name = 'admin';

-- Create index on the materialized view
CREATE UNIQUE INDEX IF NOT EXISTS admin_role_id_idx ON admin_role_id(id);

-- Create simplified policies for departments
CREATE POLICY "dept_read_policy"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "dept_write_policy"
  ON departments
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_id
      WHERE id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW admin_role_id;

-- Grant necessary permissions
GRANT ALL ON departments TO authenticated;

-- Ensure RLS is enabled
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;