/*
  # Create admin user and role

  1. Changes
    - Creates admin role if it doesn't exist
    - Creates admin user if it doesn't exist
    - Links admin user to role
  
  2. Security
    - Ensures idempotent execution
    - Maintains data integrity
    - Preserves existing admin if present
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

-- Then create the admin user if it doesn't exist
DO $$
DECLARE
  v_user_id uuid;
  v_role_id uuid;
BEGIN
  -- Get the role ID
  SELECT id INTO v_role_id FROM roles WHERE name = 'admin';
  
  -- Check if admin user exists
  IF NOT EXISTS (
    SELECT 1 FROM auth.users WHERE email = 'admin@example.com'
  ) THEN
    -- Create the user in auth.users
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
    )
    RETURNING id INTO v_user_id;
    
    -- Create the user profile
    INSERT INTO users (id, full_name, role_id)
    VALUES (v_user_id, 'System Admin', v_role_id);
  END IF;
END $$;