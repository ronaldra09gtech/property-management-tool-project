import React from 'react';
import { Save, Upload } from 'lucide-react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getThemeSettings, updateThemeSettings, getEmailSettings, updateEmailSettings } from '../../lib/api/settings';
import { useThemeStore } from '../../lib/store';

export default function Settings() {
  const queryClient = useQueryClient();
  const { settings, setSettings } = useThemeStore();
  const [isSaving, setIsSaving] = React.useState(false);
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  const { data: themeSettings } = useQuery({
    queryKey: ['themeSettings'],
    queryFn: getThemeSettings,
    onSuccess: (data) => {
      setSettings(data);
    },
  });

  const { data: emailSettings } = useQuery({
    queryKey: ['emailSettings'],
    queryFn: getEmailSettings,
  });

  const updateThemeSettingsMutation = useMutation({
    mutationFn: updateThemeSettings,
    onSuccess: (data) => {
      setSettings(data);
      queryClient.invalidateQueries({ queryKey: ['themeSettings'] });
    },
  });

  const updateEmailSettingsMutation = useMutation({
    mutationFn: updateEmailSettings,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['emailSettings'] });
    },
  });

  const handleSaveTheme = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!themeSettings?.id) return;

    setIsSaving(true);
    const form = e.target as HTMLFormElement;
    const formData = new FormData(form);
    
    try {
      await updateThemeSettingsMutation.mutateAsync({
        id: themeSettings.id,
        appName: formData.get('appName') as string,
        companyName: formData.get('companyName') as string,
        primaryColor: formData.get('primaryColor') as string,
        secondaryColor: formData.get('secondaryColor') as string,
        textColor: formData.get('textColor') as string,
        backgroundColor: formData.get('backgroundColor') as string,
        componentBackground: formData.get('componentBackground') as string,
        accentColor: formData.get('accentColor') as string,
      });
    } catch (error) {
      console.error('Error saving theme settings:', error);
    } finally {
      setIsSaving(false);
    }
  };

  const handleSaveEmail = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!emailSettings?.id) return;

    setIsSaving(true);
    const form = e.target as HTMLFormElement;
    const formData = new FormData(form);
    
    try {
      await updateEmailSettingsMutation.mutateAsync({
        id: emailSettings.id,
        smtpHost: formData.get('smtpHost') as string,
        smtpPort: parseInt(formData.get('smtpPort') as string),
        smtpUser: formData.get('smtpUser') as string,
        smtpPassword: formData.get('smtpPassword') as string,
        smtpSecure: formData.get('smtpSecure') === 'true',
        fromEmail: formData.get('fromEmail') as string,
        fromName: formData.get('fromName') as string,
        notificationTypes: Array.from(formData.getAll('notificationTypes')),
      });
    } catch (error) {
      console.error('Error saving email settings:', error);
    } finally {
      setIsSaving(false);
    }
  };

  const handleLogoUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file || !themeSettings?.id) return;

    try {
      // Here you would implement file upload logic
      // For now, we'll just use a placeholder URL
      await updateThemeSettingsMutation.mutateAsync({
        id: themeSettings.id,
        logoUrl: URL.createObjectURL(file),
      });
    } catch (error) {
      console.error('Error uploading logo:', error);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">Settings</h1>
      </div>

      {/* Theme Settings */}
      <div className="bg-white shadow-sm rounded-lg">
        <form onSubmit={handleSaveTheme} className="p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Theme Settings</h2>
          
          <div className="space-y-6">
            <div>
              <label htmlFor="appName" className="block text-sm font-medium text-gray-700">
                App Name
              </label>
              <input
                type="text"
                name="appName"
                id="appName"
                defaultValue={themeSettings?.appName}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
              />
            </div>

            <div>
              <label htmlFor="companyName" className="block text-sm font-medium text-gray-700">
                Company Name
              </label>
              <input
                type="text"
                name="companyName"
                id="companyName"
                defaultValue={themeSettings?.companyName}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Company Logo
              </label>
              <div className="mt-1 flex items-center space-x-4">
                {themeSettings?.logoUrl && (
                  <img
                    src={themeSettings.logoUrl}
                    alt="Company Logo"
                    className="h-12 w-12 object-contain"
                  />
                )}
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  className="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
                >
                  <Upload className="h-4 w-4 mr-2" />
                  Upload Logo
                </button>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={handleLogoUpload}
                />
              </div>
            </div>

            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
              <div>
                <label htmlFor="primaryColor" className="block text-sm font-medium text-gray-700">
                  Primary Color
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="primaryColor"
                    id="primaryColor"
                    defaultValue={themeSettings?.primaryColor}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.primaryColor}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>

              <div>
                <label htmlFor="secondaryColor" className="block text-sm font-medium text-gray-700">
                  Secondary Color
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="secondaryColor"
                    id="secondaryColor"
                    defaultValue={themeSettings?.secondaryColor}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.secondaryColor}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>

              <div>
                <label htmlFor="textColor" className="block text-sm font-medium text-gray-700">
                  Text Color
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="textColor"
                    id="textColor"
                    defaultValue={themeSettings?.textColor}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.textColor}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>

              <div>
                <label htmlFor="backgroundColor" className="block text-sm font-medium text-gray-700">
                  Background Color
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="backgroundColor"
                    id="backgroundColor"
                    defaultValue={themeSettings?.backgroundColor}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.backgroundColor}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>

              <div>
                <label htmlFor="componentBackground" className="block text-sm font-medium text-gray-700">
                  Component Background
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="componentBackground"
                    id="componentBackground"
                    defaultValue={themeSettings?.componentBackground}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.componentBackground}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>

              <div>
                <label htmlFor="accentColor" className="block text-sm font-medium text-gray-700">
                  Accent Color
                </label>
                <div className="mt-1 flex items-center space-x-2">
                  <input
                    type="color"
                    name="accentColor"
                    id="accentColor"
                    defaultValue={themeSettings?.accentColor}
                    className="h-8 w-8 rounded-md border border-gray-300"
                  />
                  <input
                    type="text"
                    defaultValue={themeSettings?.accentColor}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                    readOnly
                  />
                </div>
              </div>
            </div>

            <div className="pt-4">
              <button
                type="submit"
                disabled={isSaving}
                className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <Save className="h-4 w-4 mr-2" />
                {isSaving ? 'Saving...' : 'Save Theme Settings'}
              </button>
            </div>
          </div>
        </form>
      </div>

      {/* Email Settings */}
      <div className="bg-white shadow-sm rounded-lg">
        <form onSubmit={handleSaveEmail} className="p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Email Settings</h2>
          
          <div className="space-y-6">
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
              <div>
                <label htmlFor="smtpHost" className="block text-sm font-medium text-gray-700">
                  SMTP Host
                </label>
                <input
                  type="text"
                  name="smtpHost"
                  id="smtpHost"
                  defaultValue={emailSettings?.smtpHost}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>

              <div>
                <label htmlFor="smtpPort" className="block text-sm font-medium text-gray-700">
                  SMTP Port
                </label>
                <input
                  type="number"
                  name="smtpPort"
                  id="smtpPort"
                  defaultValue={emailSettings?.smtpPort}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>

              <div>
                <label htmlFor="smtpUser" className="block text-sm font-medium text-gray-700">
                  SMTP Username
                </label>
                <input
                  type="text"
                  name="smtpUser"
                  id="smtpUser"
                  defaultValue={emailSettings?.smtpUser}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>

              <div>
                <label htmlFor="smtpPassword" className="block text-sm font-medium text-gray-700">
                  SMTP Password
                </label>
                <input
                  type="password"
                  name="smtpPassword"
                  id="smtpPassword"
                  defaultValue={emailSettings?.smtpPassword}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>

              <div>
                <label htmlFor="fromEmail" className="block text-sm font-medium text-gray-700">
                  From Email
                </label>
                <input
                  type="email"
                  name="fromEmail"
                  id="fromEmail"
                  defaultValue={emailSettings?.fromEmail}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>

              <div>
                <label htmlFor="fromName" className="block text-sm font-medium text-gray-700">
                  From Name
                </label>
                <input
                  type="text"
                  name="fromName"
                  id="fromName"
                  defaultValue={emailSettings?.fromName}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                SMTP Security
              </label>
              <div className="mt-2">
                <label className="inline-flex items-center">
                  <input
                    type="radio"
                    name="smtpSecure"
                    value="true"
                    defaultChecked={emailSettings?.smtpSecure}
                    className="form-radio h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">SSL/TLS</span>
                </label>
                <label className="inline-flex items-center ml-6">
                  <input
                    type="radio"
                    name="smtpSecure"
                    value="false"
                    defaultChecked={!emailSettings?.smtpSecure}
                    className="form-radio h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">None</span>
                </label>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Notification Types
              </label>
              <div className="mt-2 space-y-2">
                <label className="inline-flex items-center">
                  <input
                    type="checkbox"
                    name="notificationTypes"
                    value="maintenance"
                    defaultChecked={emailSettings?.notificationTypes.includes('maintenance')}
                    className="form-checkbox h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">Maintenance Requests</span>
                </label>
                <label className="inline-flex items-center">
                  <input
                    type="checkbox"
                    name="notificationTypes"
                    value="payments"
                    defaultChecked={emailSettings?.notificationTypes.includes('payments')}
                    className="form-checkbox h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">Payments</span>
                </label>
                <label className="inline-flex items-center">
                  <input
                    type="checkbox"
                    name="notificationTypes"
                    value="contracts"
                    defaultChecked={emailSettings?.notificationTypes.includes('contracts')}
                    className="form-checkbox h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">Contracts</span>
                </label>
                <label className="inline-flex items-center">
                  <input
                    type="checkbox"
                    name="notificationTypes"
                    value="bookings"
                    defaultChecked={emailSettings?.notificationTypes.includes('bookings')}
                    className="form-checkbox h-4 w-4 text-indigo-600 focus:ring-indigo-500"
                  />
                  <span className="ml-2">Bookings</span>
                </label>
              </div>
            </div>

            <div className="pt-4">
              <button
                type="submit"
                disabled={isSaving}
                className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <Save className="h-4 w-4 mr-2" />
                {isSaving ? 'Saving...' : 'Save Email Settings'}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}