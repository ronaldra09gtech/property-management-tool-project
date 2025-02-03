import { supabase } from '../supabase';

export async function getUserProfile(userId: string) {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();

  if (error) throw error;
  return data;
}

export async function updateUserProfile(profile: {
  id: string;
  fullName?: string;
  email?: string;
  phone?: string;
  imageUrl?: string;
}) {
  const { data, error } = await supabase
    .from('users')
    .update({
      full_name: profile.fullName,
      email: profile.email,
      phone: profile.phone,
      image_url: profile.imageUrl,
      updated_at: new Date().toISOString(),
    })
    .eq('id', profile.id)
    .select()
    .single();

  if (error) {
    console.error('Error updating profile:', error);
    throw error;
  }

  return {
    ...data,
    fullName: data.full_name,
    imageUrl: data.image_url,
  };
}

export async function updatePassword(params: {
  id: string;
  currentPassword: string;
  newPassword: string;
}) {
  const { error } = await supabase.auth.updateUser({
    password: params.newPassword,
  });

  if (error) throw error;
}

export async function getUserLogs(userId: string) {
  const { data, error } = await supabase
    .from('user_activity_logs')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(10);

  if (error) throw error;
  return data || [];
}