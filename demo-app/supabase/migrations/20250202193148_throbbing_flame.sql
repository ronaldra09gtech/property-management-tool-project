-- First ensure we have default email settings
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

-- Update the email settings policy to handle the case of no rows
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;

CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (check_admin_access());

-- Add index for better performance
CREATE INDEX IF NOT EXISTS idx_email_settings_updated_at ON email_settings(updated_at);