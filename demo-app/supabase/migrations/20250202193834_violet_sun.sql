-- Drop existing policies and functions
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;
DROP FUNCTION IF EXISTS is_admin_user(uuid);

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

-- Create email_settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS email_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  smtp_host text NOT NULL DEFAULT 'smtp.example.com',
  smtp_port integer NOT NULL DEFAULT 587,
  smtp_user text NOT NULL DEFAULT 'notifications@example.com',
  smtp_password text NOT NULL DEFAULT 'default_password',
  smtp_secure boolean DEFAULT true,
  from_email text NOT NULL DEFAULT 'notifications@example.com',
  from_name text NOT NULL DEFAULT 'Property Management System',
  notification_types jsonb DEFAULT '["maintenance", "payments", "contracts", "bookings"]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT single_row CHECK (id = (SELECT MIN(id) FROM email_settings))
);

-- Enable RLS
ALTER TABLE email_settings ENABLE ROW LEVEL SECURITY;

-- Create a simplified policy for email settings
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (is_admin_user(auth.uid()));

-- Ensure we have exactly one row of settings
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM email_settings) THEN
    INSERT INTO email_settings (
      smtp_host,
      smtp_port,
      smtp_user,
      smtp_password,
      smtp_secure,
      from_email,
      from_name,
      notification_types
    ) VALUES (
      'smtp.example.com',
      587,
      'notifications@example.com',
      'default_password',
      true,
      'notifications@example.com',
      'Property Management System',
      '["maintenance", "payments", "contracts", "bookings"]'::jsonb
    );
  END IF;
END $$;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION is_admin_user TO authenticated;
GRANT EXECUTE ON FUNCTION is_admin_user TO anon;