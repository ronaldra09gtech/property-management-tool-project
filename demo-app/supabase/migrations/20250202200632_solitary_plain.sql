-- Drop existing policies
DROP POLICY IF EXISTS "departments_select_policy" ON departments;
DROP POLICY IF EXISTS "departments_insert_policy" ON departments;
DROP POLICY IF EXISTS "departments_update_policy" ON departments;
DROP POLICY IF EXISTS "departments_delete_policy" ON departments;

-- Create a function to check admin status with a unique name
CREATE OR REPLACE FUNCTION check_department_admin_access()
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM roles r
    JOIN users u ON u.role_id = r.id
    WHERE u.id = auth.uid()
    AND r.name = 'admin'
  );
END;
$$;

-- Create simplified policies for departments
CREATE POLICY "enable_read_for_all_authenticated"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "enable_insert_for_admins"
  ON departments
  FOR INSERT
  TO authenticated
  WITH CHECK (check_department_admin_access());

CREATE POLICY "enable_update_for_admins"
  ON departments
  FOR UPDATE
  TO authenticated
  USING (check_department_admin_access());

CREATE POLICY "enable_delete_for_admins"
  ON departments
  FOR DELETE
  TO authenticated
  USING (check_department_admin_access());

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION check_department_admin_access TO authenticated;
GRANT EXECUTE ON FUNCTION check_department_admin_access TO anon;

-- Ensure RLS is enabled
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;