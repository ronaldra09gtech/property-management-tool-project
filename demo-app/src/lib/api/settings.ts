import { supabase } from '../supabase';

export interface ThemeSettings {
  id: string;
  companyName: string;
  appName: string;
  logoUrl?: string;
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  backgroundColor: string;
  componentBackground: string;
  accentColor: string;
}

export interface EmailSettings {
  id: string;
  smtpHost: string;
  smtpPort: number;
  smtpUser: string;
  smtpPassword: string;
  smtpSecure: boolean;
  fromEmail: string;
  fromName: string;
  notificationTypes: string[];
}

export async function getThemeSettings() {
  const { data, error } = await supabase
    .from('theme_settings')
    .select('*')
    .single();

  if (error) throw error;

  return {
    id: data.id,
    companyName: data.company_name,
    appName: data.app_name,
    logoUrl: data.logo_url,
    primaryColor: data.primary_color,
    secondaryColor: data.secondary_color,
    textColor: data.text_color,
    backgroundColor: data.background_color,
    componentBackground: data.component_background,
    accentColor: data.accent_color,
  } as ThemeSettings;
}

export async function updateThemeSettings(settings: Partial<ThemeSettings>) {
  const { data, error } = await supabase
    .from('theme_settings')
    .update({
      company_name: settings.companyName,
      app_name: settings.appName,
      logo_url: settings.logoUrl,
      primary_color: settings.primaryColor,
      secondary_color: settings.secondaryColor,
      text_color: settings.textColor,
      background_color: settings.backgroundColor,
      component_background: settings.componentBackground,
      accent_color: settings.accentColor,
    })
    .eq('id', settings.id)
    .select()
    .single();

  if (error) throw error;

  return {
    id: data.id,
    companyName: data.company_name,
    appName: data.app_name,
    logoUrl: data.logo_url,
    primaryColor: data.primary_color,
    secondaryColor: data.secondary_color,
    textColor: data.text_color,
    backgroundColor: data.background_color,
    componentBackground: data.component_background,
    accentColor: data.accent_color,
  } as ThemeSettings;
}

export async function getEmailSettings() {
  const { data, error } = await supabase
    .from('email_settings')
    .select('*')
    .single();

  if (error) throw error;

  return {
    id: data.id,
    smtpHost: data.smtp_host,
    smtpPort: data.smtp_port,
    smtpUser: data.smtp_user,
    smtpPassword: data.smtp_password,
    smtpSecure: data.smtp_secure,
    fromEmail: data.from_email,
    fromName: data.from_name,
    notificationTypes: data.notification_types,
  } as EmailSettings;
}

export async function updateEmailSettings(settings: Partial<EmailSettings>) {
  const { data, error } = await supabase
    .from('email_settings')
    .update({
      smtp_host: settings.smtpHost,
      smtp_port: settings.smtpPort,
      smtp_user: settings.smtpUser,
      smtp_password: settings.smtpPassword,
      smtp_secure: settings.smtpSecure,
      from_email: settings.fromEmail,
      from_name: settings.fromName,
      notification_types: settings.notificationTypes,
    })
    .eq('id', settings.id)
    .select()
    .single();

  if (error) throw error;

  return {
    id: data.id,
    smtpHost: data.smtp_host,
    smtpPort: data.smtp_port,
    smtpUser: data.smtp_user,
    smtpPassword: data.smtp_password,
    smtpSecure: data.smtp_secure,
    fromEmail: data.from_email,
    fromName: data.from_name,
    notificationTypes: data.notification_types,
  } as EmailSettings;
}