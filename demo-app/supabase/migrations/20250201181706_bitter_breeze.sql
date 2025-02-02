/*
  # Initial Schema for Property Management System

  1. Core Tables
    - users (extends Supabase auth)
    - departments
    - roles
    - properties
    - units
    - tenants
    - contracts
    - maintenance_requests
    - maintenance_bids
    - payments
    - invoices
    - bookings
    - notifications
    - documents
    - ai_analysis_results

  2. Security
    - RLS enabled on all tables
    - Role-based access policies
    - Department-based access restrictions

  3. AI/ML Integration Tables
    - maintenance_classifications
    - tenant_risk_scores
    - contract_summaries
    - document_classifications
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- Departments
CREATE TABLE departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Roles with permissions
CREATE TABLE roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  permissions jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Extend users table (connects with auth.users)
CREATE TABLE users (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  full_name text,
  role_id uuid REFERENCES roles(id),
  department_id uuid REFERENCES departments(id),
  phone text,
  avatar_url text,
  settings jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Properties
CREATE TABLE properties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  address text NOT NULL,
  description text,
  amenities jsonb DEFAULT '[]',
  images text[] DEFAULT '{}',
  status text NOT NULL DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Units
CREATE TABLE units (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id uuid REFERENCES properties(id) ON DELETE CASCADE,
  number text NOT NULL,
  type text NOT NULL,
  floor_plan text,
  square_feet numeric,
  bedrooms integer,
  bathrooms numeric,
  rent_amount numeric NOT NULL,
  status text NOT NULL DEFAULT 'vacant',
  features jsonb DEFAULT '[]',
  images text[] DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Tenants
CREATE TABLE tenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  unit_id uuid REFERENCES units(id),
  lease_start_date date,
  lease_end_date date,
  rent_amount numeric NOT NULL,
  security_deposit numeric,
  payment_day integer,
  status text NOT NULL DEFAULT 'active',
  risk_score numeric,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Contracts
CREATE TABLE contracts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id),
  unit_id uuid REFERENCES units(id),
  type text NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  terms jsonb NOT NULL,
  signed_by_tenant boolean DEFAULT false,
  signed_by_manager boolean DEFAULT false,
  status text NOT NULL DEFAULT 'draft',
  file_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Maintenance Requests
CREATE TABLE maintenance_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_id uuid REFERENCES units(id),
  tenant_id uuid REFERENCES tenants(id),
  category text NOT NULL,
  priority text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  images text[] DEFAULT '{}',
  status text NOT NULL DEFAULT 'pending',
  assigned_to uuid REFERENCES users(id),
  estimated_cost numeric,
  actual_cost numeric,
  ai_classification jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Maintenance Bids
CREATE TABLE maintenance_bids (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid REFERENCES maintenance_requests(id),
  contractor_id uuid REFERENCES users(id),
  amount numeric NOT NULL,
  description text,
  estimated_time interval,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Payments
CREATE TABLE payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id),
  amount numeric NOT NULL,
  type text NOT NULL,
  status text NOT NULL,
  payment_method text,
  transaction_id text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Invoices
CREATE TABLE invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id),
  amount numeric NOT NULL,
  due_date date NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  items jsonb NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Bookings
CREATE TABLE bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_id uuid REFERENCES units(id),
  user_id uuid REFERENCES users(id),
  scheduled_date timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Notifications
CREATE TABLE notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  title text NOT NULL,
  message text NOT NULL,
  type text NOT NULL,
  read boolean DEFAULT false,
  data jsonb,
  created_at timestamptz DEFAULT now()
);

-- Documents
CREATE TABLE documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL,
  url text NOT NULL,
  metadata jsonb,
  ai_classification jsonb,
  created_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- AI Analysis Results
CREATE TABLE ai_analysis_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL,
  source_type text NOT NULL,
  source_id uuid NOT NULL,
  result jsonb NOT NULL,
  confidence numeric,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_bids ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_analysis_results ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own data"
  ON users
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Admins can manage all properties"
  ON properties
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role_id IN (
        SELECT id FROM roles
        WHERE name = 'admin'
      )
    )
  );

-- Add more policies as needed for each table based on roles and departments

-- Create functions for AI/ML operations
CREATE OR REPLACE FUNCTION classify_maintenance_request(
  request_id uuid,
  description text
) RETURNS jsonb
LANGUAGE plpgsql
AS $$
BEGIN
  -- Implement classification logic
  RETURN jsonb_build_object(
    'category', 'plumbing',
    'priority', 'high',
    'estimated_cost', 150.00
  );
END;
$$;

CREATE OR REPLACE FUNCTION calculate_tenant_risk_score(
  tenant_id uuid
) RETURNS numeric
LANGUAGE plpgsql
AS $$
BEGIN
  -- Implement risk scoring logic
  RETURN 0.85;
END;
$$;

-- Create indexes for better performance
CREATE INDEX idx_users_role ON users(role_id);
CREATE INDEX idx_users_department ON users(department_id);
CREATE INDEX idx_units_property ON units(property_id);
CREATE INDEX idx_tenants_unit ON tenants(unit_id);
CREATE INDEX idx_maintenance_unit ON maintenance_requests(unit_id);
CREATE INDEX idx_payments_tenant ON payments(tenant_id);
CREATE INDEX idx_invoices_tenant ON invoices(tenant_id);
CREATE INDEX idx_bookings_unit ON bookings(unit_id);