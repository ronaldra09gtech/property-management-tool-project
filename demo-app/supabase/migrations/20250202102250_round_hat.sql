/*
  # Create initial admin user

  1. New Data
    - Creates an admin role
    - Creates an initial admin user
  
  2. Security
    - Ensures proper role assignment
    - Sets up initial authentication
*/

-- First, create the admin role if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM roles WHERE name = 'admin'
  ) THEN
    INSERT INTO roles (name, permissions)
    VALUES (
      'admin',
      '{"all": true}'
    );
  END IF;
END $$;

-- Then create the admin user
INSERT INTO auth.users (
  id,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  role
) VALUES (
  gen_random_uuid(),
  'admin@example.com',
  crypt('Admin123!', gen_salt('bf')),
  now(),
  '{"provider": "email", "providers": ["email"]}',
  '{"name": "System Admin"}',
  now(),
  now(),
  'authenticated'
);

-- Get the user ID we just created
DO $$ 
DECLARE
  v_user_id uuid;
  v_role_id uuid;
BEGIN
  SELECT id INTO v_user_id FROM auth.users WHERE email = 'admin@example.com';
  SELECT id INTO v_role_id FROM roles WHERE name = 'admin';
  
  -- Create the user profile
  INSERT INTO users (id, full_name, role_id)
  VALUES (v_user_id, 'System Admin', v_role_id);
END $$;