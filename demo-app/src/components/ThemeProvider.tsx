import React from 'react';
import { useThemeStore } from '../lib/store';

export default function ThemeProvider({ children }: { children: React.ReactNode }) {
  const { settings } = useThemeStore();

  React.useEffect(() => {
    if (settings) {
      const root = document.documentElement;
      root.style.setProperty('--color-primary', settings.primaryColor);
      root.style.setProperty('--color-secondary', settings.secondaryColor);
      root.style.setProperty('--color-text', settings.textColor);
      root.style.setProperty('--color-background', settings.backgroundColor);
      root.style.setProperty('--color-component', settings.componentBackground);
      root.style.setProperty('--color-accent', settings.accentColor);
    }
  }, [settings]);

  return <>{children}</>;
}