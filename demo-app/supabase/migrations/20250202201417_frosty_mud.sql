-- Drop existing policies
DROP POLICY IF EXISTS "email_settings_access" ON email_settings;

-- Recreate email_settings table with proper structure
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

-- Create a simplified policy for email settings
CREATE POLICY "email_settings_access"
  ON email_settings
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_role_cache
      WHERE role_id = (SELECT role_id FROM users WHERE id = auth.uid())
    )
  );

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
      '["maintenance", "payments", "contracts", "bookings"]'
    );
  END IF;
END $$;