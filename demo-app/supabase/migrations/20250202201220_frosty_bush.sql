-- Drop all existing policies
DROP POLICY IF EXISTS "allow_read_departments" ON departments;
DROP POLICY IF EXISTS "allow_manage_departments" ON departments;
DROP POLICY IF EXISTS "dept_read_policy" ON departments;
DROP POLICY IF EXISTS "dept_write_policy" ON departments;

-- Drop existing function if exists
DROP FUNCTION IF EXISTS is_department_admin();

-- Create a cache table for admin role
CREATE TABLE IF NOT EXISTS admin_role_cache (
  role_id uuid PRIMARY KEY,
  updated_at timestamptz DEFAULT now()
);

-- Insert admin role ID if not exists
INSERT INTO admin_role_cache (role_id)
SELECT id FROM roles WHERE name = 'admin'
ON CONFLICT DO NOTHING;

-- Create simple non-recursive policies
CREATE POLICY "departments_select"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "departments_insert"
  ON departments
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

CREATE POLICY "departments_update"
  ON departments
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

CREATE POLICY "departments_delete"
  ON departments
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_admin_role_cache_role_id ON admin_role_cache(role_id);

-- Ensure RLS is enabled
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT ALL ON departments TO authenticated;