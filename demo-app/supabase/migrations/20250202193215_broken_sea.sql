-- Drop existing policies to start fresh
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;

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
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE email_settings ENABLE ROW LEVEL SECURITY;

-- Create a simplified policy without recursion
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM roles r
      WHERE r.id = (
        SELECT role_id FROM users WHERE id = auth.uid() LIMIT 1
      )
      AND r.name = 'admin'
    )
  );

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
CREATE INDEX IF NOT EXISTS idx_email_settings_updated_at ON email_settings(updated_at);