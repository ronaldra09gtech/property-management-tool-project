-- Drop existing policies to start fresh
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;

-- Create a materialized view for admin role ID to avoid recursion
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_role_id AS
SELECT id FROM roles WHERE name = 'admin';

-- Create index on the materialized view
CREATE UNIQUE INDEX IF NOT EXISTS admin_role_id_idx ON admin_role_id(id);

-- Create a simplified policy using the materialized view
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM admin_role_id)
    )
  );

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW admin_role_id;

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