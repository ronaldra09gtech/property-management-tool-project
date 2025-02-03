/*
  # Create Super Admin Account

  1. Changes
    - Create admin role if it doesn't exist
    - Create super admin user with specified credentials
    - Set up proper role assignments and permissions

  2. Security
    - Ensure proper role assignment
    - Set up secure password
    - Enable proper access control
*/

-- First ensure admin role exists
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM roles WHERE name = 'admin'
  ) THEN
    INSERT INTO roles (name, permissions)
    VALUES ('admin', '{"all": true}');
  END IF;
END $$;

-- Create super admin user if doesn't exist
DO $$
DECLARE
  v_user_id uuid;
  v_role_id uuid;
BEGIN
  -- Get admin role ID
  SELECT id INTO v_role_id FROM roles WHERE name = 'admin';
  
  -- Only proceed if user doesn't exist
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ronaldra09gtech@gmail.com') THEN
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
      'ronaldra09gtech@gmail.com',
      crypt('JanineAvila19', gen_salt('bf')),
      now(),
      '{"provider": "email", "providers": ["email"]}',
      '{"name": "Super Admin"}',
      now(),
      now()
    ) RETURNING id INTO v_user_id;

    -- Create user profile with admin role
    INSERT INTO users (
      id,
      full_name,
      email,
      role_id
    ) VALUES (
      v_user_id,
      'Super Admin',
      'ronaldra09gtech@gmail.com',
      v_role_id
    );
  END IF;
END $$;