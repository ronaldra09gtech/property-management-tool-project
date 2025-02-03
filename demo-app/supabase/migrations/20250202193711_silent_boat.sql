-- Drop existing policies and views
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;
DROP MATERIALIZED VIEW IF EXISTS admin_role_id;

-- Create a function to check admin status without recursion
CREATE OR REPLACE FUNCTION is_admin_user(user_id uuid)
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
  WHERE u.id = user_id
  LIMIT 1;
  
  RETURN COALESCE(v_role_name = 'admin', false);
END;
$$;

-- Create a simplified policy for email settings
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (is_admin_user(auth.uid()));

-- Ensure we have at least one row of settings
INSERT INTO email_settings (
  smtp_host,
  smtp_port,
  smtp_user,
  smtp_password,
  smtp_secure,
  from_email,
  from_name,
  notification_types
)
SELECT
  'smtp.example.com',
  587,
  'notifications@example.com',
  'default_password',
  true,
  'notifications@example.com',
  'Property Management System',
  '["maintenance", "payments", "contracts", "bookings"]'::jsonb
WHERE NOT EXISTS (
  SELECT 1 FROM email_settings LIMIT 1
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION is_admin_user TO authenticated;
GRANT EXECUTE ON FUNCTION is_admin_user TO anon;