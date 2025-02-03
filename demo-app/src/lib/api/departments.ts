import { supabase } from '../supabase';

export interface Department {
  id: string;
  name: string;
  description?: string;
  status: 'active' | 'inactive';
  createdAt: string;
  updatedAt: string;
}

export async function getDepartments() {
  const { data, error } = await supabase
    .from('departments')
    .select('*')
    .order('name');

  if (error) {
    console.error('Error fetching departments:', error);
    throw new Error('Failed to fetch departments');
  }

  return data as Department[];
}

export async function createDepartment(department: Omit<Department, 'id' | 'createdAt' | 'updatedAt'>) {
  const { data, error } = await supabase
    .from('departments')
    .insert([
      {
        name: department.name,
        description: department.description,
        status: department.status,
      },
    ])
    .select()
    .single();

  if (error) {
    console.error('Error creating department:', error);
    throw new Error('Failed to create department');
  }

  return data as Department;
}

export async function updateDepartment(id: string, department: Partial<Department>) {
  const { data, error } = await supabase
    .from('departments')
    .update({
      name: department.name,
      description: department.description,
      status: department.status,
    })
    .eq('id', id)
    .select()
    .single();

  if (error) {
    console.error('Error updating department:', error);
    throw new Error('Failed to update department');
  }

  return data as Department;
}

export async function deleteDepartment(id: string) {
  const { error } = await supabase
    .from('departments')
    .delete()
    .eq('id', id);

  if (error) {
    console.error('Error deleting department:', error);
    throw new Error('Failed to delete department');
  }
}