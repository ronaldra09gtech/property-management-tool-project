/*
  # Add User Activity Logs

  1. New Tables
    - user_activity_logs
      - id (uuid, primary key)
      - user_id (uuid, references users)
      - action (text)
      - metadata (jsonb)
      - created_at (timestamptz)

  2. Security
    - Enable RLS
    - Add policies for log access
*/

-- Create user_activity_logs table
CREATE TABLE IF NOT EXISTS user_activity_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  action text NOT NULL,
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE user_activity_logs ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Admins can view all logs"
  ON user_activity_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      JOIN roles r ON u.role_id = r.id
      WHERE u.id = auth.uid()
      AND r.name = 'admin'
    )
  );

-- Create index for better performance
CREATE INDEX idx_user_activity_logs_user_id ON user_activity_logs(user_id);
CREATE INDEX idx_user_activity_logs_created_at ON user_activity_logs(created_at);

-- Create function to log user activity
CREATE OR REPLACE FUNCTION log_user_activity()
RETURNS trigger AS $$
BEGIN
  INSERT INTO user_activity_logs (user_id, action, metadata)
  VALUES (
    NEW.id,
    CASE
      WHEN TG_OP = 'INSERT' THEN 'profile_created'
      WHEN TG_OP = 'UPDATE' THEN 'profile_updated'
      ELSE 'profile_' || lower(TG_OP)
    END,
    jsonb_build_object(
      'changes', jsonb_build_object(
        'old', to_jsonb(OLD),
        'new', to_jsonb(NEW)
      )
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for user activity logging
CREATE TRIGGER log_user_changes
  AFTER INSERT OR UPDATE
  ON users
  FOR EACH ROW
  EXECUTE FUNCTION log_user_activity();