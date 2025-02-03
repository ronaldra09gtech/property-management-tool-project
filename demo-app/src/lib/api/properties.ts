import { supabase } from '../supabase';
import type { Property } from '../../types';

export async function getProperties() {
  const { data, error } = await supabase
    .from('properties')
    .select(`
      id,
      name,
      address,
      description,
      units,
      occupancy_rate,
      revenue,
      amenities,
      image_url,
      status,
      created_at,
      updated_at,
      owner:owner_id(id, full_name, email, phone, image_url),
      manager:manager_id(id, full_name, email, phone, image_url)
    `);

  if (error) {
    console.error('Error fetching properties:', error);
    throw error;
  }

  return data?.map(property => ({
    id: property.id,
    name: property.name,
    address: property.address,
    description: property.description,
    units: property.units,
    occupancyRate: property.occupancy_rate,
    revenue: property.revenue,
    amenities: property.amenities,
    imageUrl: property.image_url || 'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=800&h=400',
    status: property.status,
    owner: {
      id: property.owner?.id,
      name: property.owner?.full_name || 'Not Assigned',
      email: property.owner?.email || '',
      phone: property.owner?.phone || '',
      imageUrl: property.owner?.image_url || `https://ui-avatars.com/api/?name=${property.owner?.full_name || 'Owner'}&background=random`,
      role: 'owner'
    },
    propertyManager: {
      id: property.manager?.id,
      name: property.manager?.full_name || 'Not Assigned',
      email: property.manager?.email || '',
      phone: property.manager?.phone || '',
      imageUrl: property.manager?.image_url || `https://ui-avatars.com/api/?name=${property.manager?.full_name || 'Manager'}&background=random`,
      role: 'manager'
    },
    createdAt: property.created_at,
    updatedAt: property.updated_at
  })) as Property[];
}

export async function getProperty(id: string) {
  const { data, error } = await supabase
    .from('properties')
    .select(`
      id,
      name,
      address,
      description,
      units,
      occupancy_rate,
      revenue,
      amenities,
      image_url,
      status,
      created_at,
      updated_at,
      owner:owner_id(id, full_name, email, phone, image_url),
      manager:manager_id(id, full_name, email, phone, image_url)
    `)
    .eq('id', id)
    .single();

  if (error) throw error;

  return {
    id: data.id,
    name: data.name,
    address: data.address,
    description: data.description,
    units: data.units,
    occupancyRate: data.occupancy_rate,
    revenue: data.revenue,
    amenities: data.amenities,
    imageUrl: data.image_url || 'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=800&h=400',
    status: data.status,
    owner: {
      id: data.owner?.id,
      name: data.owner?.full_name || 'Not Assigned',
      email: data.owner?.email || '',
      phone: data.owner?.phone || '',
      imageUrl: data.owner?.image_url || `https://ui-avatars.com/api/?name=${data.owner?.full_name || 'Owner'}&background=random`,
      role: 'owner'
    },
    propertyManager: {
      id: data.manager?.id,
      name: data.manager?.full_name || 'Not Assigned',
      email: data.manager?.email || '',
      phone: data.manager?.phone || '',
      imageUrl: data.manager?.image_url || `https://ui-avatars.com/api/?name=${data.manager?.full_name || 'Manager'}&background=random`,
      role: 'manager'
    },
    createdAt: data.created_at,
    updatedAt: data.updated_at
  } as Property;
}

export async function createProperty(property: Omit<Property, 'id' | 'createdAt' | 'updatedAt'>) {
  // First create or get the owner
  const { data: ownerData, error: ownerError } = await supabase
    .from('users')
    .upsert([
      {
        full_name: property.owner.name,
        email: property.owner.email,
        phone: property.owner.phone,
        role_id: (await supabase.from('roles').select('id').eq('name', 'owner').single()).data?.id,
      },
    ])
    .select()
    .single();

  if (ownerError) throw ownerError;

  // Then create or get the property manager
  const { data: managerData, error: managerError } = await supabase
    .from('users')
    .upsert([
      {
        full_name: property.propertyManager.name,
        email: property.propertyManager.email,
        phone: property.propertyManager.phone,
        role_id: (await supabase.from('roles').select('id').eq('name', 'manager').single()).data?.id,
      },
    ])
    .select()
    .single();

  if (managerError) throw managerError;

  // Finally create the property
  const { data, error } = await supabase
    .from('properties')
    .insert([
      {
        name: property.name,
        address: property.address,
        description: property.description || '',
        units: property.units,
        occupancy_rate: property.occupancyRate || 0,
        revenue: property.revenue || 0,
        amenities: property.amenities || [],
        image_url: property.imageUrl,
        status: property.status,
        owner_id: ownerData.id,
        manager_id: managerData.id,
      },
    ])
    .select(`
      id,
      name,
      address,
      description,
      units,
      occupancy_rate,
      revenue,
      amenities,
      image_url,
      status,
      created_at,
      updated_at,
      owner:owner_id(id, full_name, email, phone, image_url),
      manager:manager_id(id, full_name, email, phone, image_url)
    `)
    .single();

  if (error) throw error;

  return {
    id: data.id,
    name: data.name,
    address: data.address,
    description: data.description,
    units: data.units,
    occupancyRate: data.occupancy_rate,
    revenue: data.revenue,
    amenities: data.amenities,
    imageUrl: data.image_url || 'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=800&h=400',
    status: data.status,
    owner: {
      id: data.owner?.id,
      name: data.owner?.full_name || 'Not Assigned',
      email: data.owner?.email || '',
      phone: data.owner?.phone || '',
      imageUrl: data.owner?.image_url || `https://ui-avatars.com/api/?name=${data.owner?.full_name || 'Owner'}&background=random`,
      role: 'owner'
    },
    propertyManager: {
      id: data.manager?.id,
      name: data.manager?.full_name || 'Not Assigned',
      email: data.manager?.email || '',
      phone: data.manager?.phone || '',
      imageUrl: data.manager?.image_url || `https://ui-avatars.com/api/?name=${data.manager?.full_name || 'Manager'}&background=random`,
      role: 'manager'
    },
    createdAt: data.created_at,
    updatedAt: data.updated_at
  } as Property;
}

export async function updateProperty(id: string, property: Partial<Property>) {
  const { data, error } = await supabase
    .from('properties')
    .update({
      name: property.name,
      address: property.address,
      description: property.description,
      units: property.units,
      occupancy_rate: property.occupancyRate,
      revenue: property.revenue,
      amenities: property.amenities,
      image_url: property.imageUrl,
      status: property.status,
      owner_id: property.owner?.id,
      manager_id: property.propertyManager?.id,
    })
    .eq('id', id)
    .select(`
      id,
      name,
      address,
      description,
      units,
      occupancy_rate,
      revenue,
      amenities,
      image_url,
      status,
      created_at,
      updated_at,
      owner:owner_id(id, full_name, email, phone, image_url),
      manager:manager_id(id, full_name, email, phone, image_url)
    `)
    .single();

  if (error) throw error;

  return {
    id: data.id,
    name: data.name,
    address: data.address,
    description: data.description,
    units: data.units,
    occupancyRate: data.occupancy_rate,
    revenue: data.revenue,
    amenities: data.amenities,
    imageUrl: data.image_url || 'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=800&h=400',
    status: data.status,
    owner: {
      id: data.owner?.id,
      name: data.owner?.full_name || 'Not Assigned',
      email: data.owner?.email || '',
      phone: data.owner?.phone || '',
      imageUrl: data.owner?.image_url || `https://ui-avatars.com/api/?name=${data.owner?.full_name || 'Owner'}&background=random`,
      role: 'owner'
    },
    propertyManager: {
      id: data.manager?.id,
      name: data.manager?.full_name || 'Not Assigned',
      email: data.manager?.email || '',
      phone: data.manager?.phone || '',
      imageUrl: data.manager?.image_url || `https://ui-avatars.com/api/?name=${data.manager?.full_name || 'Manager'}&background=random`,
      role: 'manager'
    },
    createdAt: data.created_at,
    updatedAt: data.updated_at
  } as Property;
}

export async function deleteProperty(id: string) {
  const { error } = await supabase
    .from('properties')
    .delete()
    .eq('id', id);

  if (error) throw error;
}

// export { createProperty }