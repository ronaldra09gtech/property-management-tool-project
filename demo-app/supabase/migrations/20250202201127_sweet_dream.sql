-- Drop all existing policies
DROP POLICY IF EXISTS "departments_read_policy" ON departments;
DROP POLICY IF EXISTS "departments_insert_policy" ON departments;
DROP POLICY IF EXISTS "departments_update_policy" ON departments;
DROP POLICY IF EXISTS "departments_delete_policy" ON departments;
DROP POLICY IF EXISTS "departments_read" ON departments;
DROP POLICY IF EXISTS "departments_write" ON departments;

-- Create a secure function to check admin status
CREATE OR REPLACE FUNCTION is_department_admin()
RETURNS boolean
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
  v_role_name text;
BEGIN
  SELECT name INTO v_role_name
  FROM roles
  WHERE id = (
    SELECT role_id 
    FROM users 
    WHERE id = auth.uid()
    LIMIT 1
  );
  
  RETURN COALESCE(v_role_name = 'admin', false);
END;
$$;

-- Create simple policies for departments
CREATE POLICY "allow_read_departments"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_manage_departments"
  ON departments
  FOR ALL
  TO authenticated
  USING (is_department_admin());

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION is_department_admin TO authenticated;
GRANT EXECUTE ON FUNCTION is_department_admin TO anon;
GRANT ALL ON departments TO authenticated;

-- Ensure RLS is enabled
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;