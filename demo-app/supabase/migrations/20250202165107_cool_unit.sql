/*
  # Add missing columns to properties table

  1. Changes
    - Add missing columns to properties table:
      - units (integer)
      - occupancy_rate (numeric)
      - revenue (numeric)

  2. Security
    - No changes to RLS policies needed
*/

-- Add missing columns to properties table
ALTER TABLE properties
ADD COLUMN IF NOT EXISTS units integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS occupancy_rate numeric DEFAULT 0,
ADD COLUMN IF NOT EXISTS revenue numeric DEFAULT 0;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_properties_units ON properties(units);
CREATE INDEX IF NOT EXISTS idx_properties_occupancy_rate ON properties(occupancy_rate);
CREATE INDEX IF NOT EXISTS idx_properties_revenue ON properties(revenue);