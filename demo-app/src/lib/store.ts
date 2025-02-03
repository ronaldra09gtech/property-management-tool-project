import { create } from 'zustand';
import { supabase } from './supabase';
import type { ThemeSettings } from './api/settings';

interface AuthState {
  user: any | null;
  session: any | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  initialize: () => Promise<void>;
}

interface ThemeState {
  settings: ThemeSettings | null;
  setSettings: (settings: ThemeSettings) => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  session: null,
  loading: true,
  signIn: async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) throw error;
    set({ user: data.user, session: data.session });
  },
  signOut: async () => {
    await supabase.auth.signOut();
    set({ user: null, session: null });
  },
  initialize: async () => {
    const { data: { session } } = await supabase.auth.getSession();
    set({ 
      session,
      user: session?.user ?? null,
      loading: false
    });

    supabase.auth.onAuthStateChange((_event, session) => {
      set({ 
        session,
        user: session?.user ?? null
      });
    });
  },
}));

export const useThemeStore = create<ThemeState>((set) => ({
  settings: null,
  setSettings: (settings) => set({ settings }),
}));