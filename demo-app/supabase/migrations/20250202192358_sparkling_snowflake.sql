-- Create theme_settings table
CREATE TABLE IF NOT EXISTS theme_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name text NOT NULL DEFAULT 'Property Management Co.',
  logo_url text,
  primary_color text DEFAULT '#4F46E5',
  secondary_color text DEFAULT '#6366F1',
  text_color text DEFAULT '#111827',
  background_color text DEFAULT '#F9FAFB',
  component_background text DEFAULT '#FFFFFF',
  accent_color text DEFAULT '#3B82F6',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE theme_settings ENABLE ROW LEVEL SECURITY;

-- Create read policy
CREATE POLICY "enable_read_theme_settings"
  ON theme_settings
  FOR SELECT
  TO authenticated
  USING (true);

-- Create update policy for admins
CREATE POLICY "enable_update_theme_settings"
  ON theme_settings
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
CREATE FUNCTION update_theme_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER update_theme_settings_timestamp
  BEFORE UPDATE ON theme_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_theme_settings_updated_at();

-- Insert default settings
INSERT INTO theme_settings (
  company_name,
  primary_color,
  secondary_color,
  text_color,
  background_color,
  component_background,
  accent_color
) VALUES (
  'Property Management Co.',
  '#4F46E5',
  '#6366F1',
  '#111827',
  '#F9FAFB',
  '#FFFFFF',
  '#3B82F6'
);