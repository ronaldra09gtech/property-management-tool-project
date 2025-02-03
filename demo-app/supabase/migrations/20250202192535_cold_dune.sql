-- Add app_name column to theme_settings table
ALTER TABLE theme_settings 
ADD COLUMN IF NOT EXISTS app_name text NOT NULL DEFAULT 'PropManager';

-- Update existing records to have a default app_name
UPDATE theme_settings 
SET app_name = 'PropManager' 
WHERE app_name IS NULL;