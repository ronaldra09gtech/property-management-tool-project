-- Drop all existing policies first
DROP POLICY IF EXISTS "departments_read" ON departments;
DROP POLICY IF EXISTS "departments_write" ON departments;
DROP POLICY IF EXISTS "departments_read_policy" ON departments;
DROP POLICY IF EXISTS "departments_insert_policy" ON departments;
DROP POLICY IF EXISTS "departments_update_policy" ON departments;
DROP POLICY IF EXISTS "departments_delete_policy" ON departments;
DROP POLICY IF EXISTS "enable_read_for_all_authenticated" ON departments;
DROP POLICY IF EXISTS "enable_insert_for_admins" ON departments;
DROP POLICY IF EXISTS "enable_update_for_admins" ON departments;
DROP POLICY IF EXISTS "enable_delete_for_admins" ON departments;

-- Create new simplified policies with unique names
CREATE POLICY "dept_select_policy"
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
      SELECT 1 FROM roles r
      WHERE r.id = (SELECT role_id FROM users WHERE id = auth.uid())
      AND r.name = 'admin'
    )
  );

-- Grant necessary permissions
GRANT ALL ON departments TO authenticated;