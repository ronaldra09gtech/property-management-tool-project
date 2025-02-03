-- Create departments table if it doesn't exist
CREATE TABLE IF NOT EXISTS departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Add manager_id column after table creation
ALTER TABLE departments
ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES users(id),
ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'active';

-- Enable RLS
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "departments_read_policy" ON departments;
DROP POLICY IF EXISTS "departments_write_policy" ON departments;

-- Create new policies for departments
CREATE POLICY "departments_select"
  ON departments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "departments_write"
  ON departments
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

-- Add department_id to users table if it doesn't exist
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS department_id uuid REFERENCES departments(id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_departments_manager ON departments(manager_id);
CREATE INDEX IF NOT EXISTS idx_departments_status ON departments(status);
CREATE INDEX IF NOT EXISTS idx_users_department ON users(department_id);

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_departments_updated_at ON departments;
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updating timestamps
CREATE TRIGGER update_departments_updated_at
  BEFORE UPDATE ON departments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();