-- Drop existing policies and function
DROP POLICY IF EXISTS "enable_read_for_all_authenticated" ON departments;
DROP POLICY IF EXISTS "enable_insert_for_admins" ON departments;
DROP POLICY IF EXISTS "enable_update_for_admins" ON departments;
DROP POLICY IF EXISTS "enable_delete_for_admins" ON departments;
DROP FUNCTION IF EXISTS check_department_admin_access();

-- Create a function to check admin status
CREATE OR REPLACE FUNCTION check_department_admin_access()
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  v_role_name text;
BEGIN
  SELECT r.name INTO v_role_name
  FROM roles r
  JOIN users u ON u.role_id = r.id
  WHERE u.id = auth.uid()
  LIMIT 1;
  
  RETURN COALESCE(v_role_name = 'admin', false);
END;
$$;

-- Enable RLS
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

-- Create policies
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
      SELECT 1 FROM roles r
      JOIN users u ON u.role_id = r.id
      WHERE u.id = auth.uid()
      AND r.name = 'admin'
    )
  );

CREATE POLICY "departments_update_policy"
  ON departments
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles r
      JOIN users u ON u.role_id = r.id
      WHERE u.id = auth.uid()
      AND r.name = 'admin'
    )
  );

CREATE POLICY "departments_delete_policy"
  ON departments
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles r
      JOIN users u ON u.role_id = r.id
      WHERE u.id = auth.uid()
      AND r.name = 'admin'
    )
  );

-- Grant necessary permissions
GRANT ALL ON departments TO authenticated;
GRANT EXECUTE ON FUNCTION check_department_admin_access TO authenticated;
GRANT EXECUTE ON FUNCTION check_department_admin_access TO anon;