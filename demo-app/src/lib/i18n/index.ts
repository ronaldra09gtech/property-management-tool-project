import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import { useSettingsStore } from '../store';

// Import translations
import en from './locales/en.json';
import ja from './locales/ja.json';

const resources = {
  en: { translation: en },
  ja: { translation: ja }
};

// Initialize i18next
i18n
  .use(initReactI18next)
  .use(LanguageDetector)
  .init({
    resources,
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false,
    },
    detection: {
      order: ['localStorage', 'querystring', 'navigator'],
      lookupLocalStorage: 'i18nextLng',
      caches: ['localStorage'],
    },
    react: {
      useSuspense: true,
      bindI18n: 'languageChanged loaded',
      bindI18nStore: 'added removed',
    }
  });

// Initialize language from store and sync with i18next
const initialLanguage = useSettingsStore.getState().language;
if (initialLanguage) {
  i18n.changeLanguage(initialLanguage);
  document.documentElement.lang = initialLanguage;
}

// Listen for language changes in the store and sync with i18next
useSettingsStore.subscribe(
  (state) => state.language,
  (language) => {
    if (language && i18n.language !== language) {
      i18n.changeLanguage(language).catch(console.error);
      document.documentElement.lang = language;
      document.cookie = `i18next=${language}; path=/; max-age=31536000`; // 1 year
    }
  }
);

// Listen for i18next language changes and sync with store
i18n.on('languageChanged', (language) => {
  const currentStoreLanguage = useSettingsStore.getState().language;
  if (currentStoreLanguage !== language) {
    useSettingsStore.getState().setLanguage(language);
  }
});

export default i18n;