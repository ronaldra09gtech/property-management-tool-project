-- Create email_settings table
CREATE TABLE IF NOT EXISTS email_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  smtp_host text NOT NULL,
  smtp_port integer NOT NULL,
  smtp_user text NOT NULL,
  smtp_password text NOT NULL,
  smtp_secure boolean DEFAULT true,
  from_email text NOT NULL,
  from_name text NOT NULL,
  notification_types jsonb DEFAULT '["maintenance", "payments", "contracts", "bookings"]',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE email_settings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "enable_read_email_settings"
  ON email_settings
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

CREATE POLICY "enable_update_email_settings"
  ON email_settings
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (SELECT id FROM roles WHERE name = 'admin')
    )
  );

-- Create timestamp update function
CREATE OR REPLACE FUNCTION update_email_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER update_email_settings_timestamp
  BEFORE UPDATE ON email_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_email_settings_updated_at();

-- Insert default settings
INSERT INTO email_settings (
  smtp_host,
  smtp_port,
  smtp_user,
  smtp_password,
  smtp_secure,
  from_email,
  from_name
) VALUES (
  'smtp.example.com',
  587,
  'notifications@example.com',
  'default_password',
  true,
  'notifications@example.com',
  'Property Management System'
);