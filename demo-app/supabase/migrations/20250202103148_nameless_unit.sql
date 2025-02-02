/*
  # Create admin role and user

  1. Changes
    - Create admin role with full permissions
    - Create admin user with secure password
    - Set up basic user policies
  
  2. Security
    - Enable RLS for users table
    - Add basic access policies
*/

-- Create admin role if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM roles WHERE name = 'admin'
  ) THEN
    INSERT INTO roles (name, permissions)
    VALUES ('admin', '{"all": true}');
  END IF;
END $$;

-- Create admin user if doesn't exist
DO $$
DECLARE
  v_user_id uuid;
  v_role_id uuid;
BEGIN
  -- Get admin role ID
  SELECT id INTO v_role_id FROM roles WHERE name = 'admin';
  
  -- Only proceed if admin user doesn't exist
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'admin@example.com') THEN
    -- Create admin user
    INSERT INTO auth.users (
      instance_id,
      id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      gen_random_uuid(),
      'authenticated',
      'authenticated',
      'admin@example.com',
      crypt('Admin123!', gen_salt('bf')),
      now(),
      '{"provider": "email", "providers": ["email"]}',
      '{"name": "System Admin"}',
      now(),
      now()
    ) RETURNING id INTO v_user_id;

    -- Create user profile
    INSERT INTO users (id, full_name, role_id)
    VALUES (v_user_id, 'System Admin', v_role_id);
  END IF;
END $$;

-- Set up basic policies
DO $$
BEGIN
  -- Enable RLS
  ALTER TABLE users ENABLE ROW LEVEL SECURITY;

  -- Create policies if they don't exist
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Users can read own data'
  ) THEN
    CREATE POLICY "Users can read own data"
      ON users
      FOR SELECT
      TO authenticated
      USING (auth.uid() = id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Users can update own data'
  ) THEN
    CREATE POLICY "Users can update own data"
      ON users
      FOR UPDATE
      TO authenticated
      USING (auth.uid() = id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Admins can read all users'
  ) THEN
    CREATE POLICY "Admins can read all users"
      ON users
      FOR SELECT
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM users u
          WHERE u.id = auth.uid()
          AND u.role_id IN (SELECT id FROM roles WHERE name = 'admin')
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Admins can update all users'
  ) THEN
    CREATE POLICY "Admins can update all users"
      ON users
      FOR UPDATE
      TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM users u
          WHERE u.id = auth.uid()
          AND u.role_id IN (SELECT id FROM roles WHERE name = 'admin')
        )
      );
  END IF;
END $$;