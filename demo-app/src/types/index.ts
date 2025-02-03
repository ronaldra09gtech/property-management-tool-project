export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'manager' | 'tenant' | 'contractor' | 'owner';
  department?: string;
  phone?: string;
  imageUrl?: string;
}

export interface Property {
  id: string;
  name: string;
  address: string;
  units: Unit[];
  imageUrl: string;
  status: 'active' | 'inactive';
  owner: User;
  propertyManager: User;
  revenue: number;
  occupancyRate: number;
  createdAt: string;
  updatedAt: string;
}

export interface Unit {
  id: string;
  propertyId: string;
  number: string;
  type: 'studio' | '1bed' | '2bed' | '3bed' | 'commercial';
  status: 'vacant' | 'occupied' | 'maintenance';
  rent: number;
  tenant?: User;
}

export interface MaintenanceRequest {
  id: string;
  propertyId: string;
  unitId: string;
  tenantId: string;
  title: string;
  description: string;
  priority: 'low' | 'medium' | 'high' | 'emergency';
  status: 'pending' | 'approved' | 'in_progress' | 'completed' | 'rejected';
  category: 'plumbing' | 'electrical' | 'hvac' | 'structural' | 'appliance' | 'other';
  images: string[];
  createdAt: string;
  updatedAt: string;
  assignedTo?: User;
  estimatedCost?: number;
  actualCost?: number;
}