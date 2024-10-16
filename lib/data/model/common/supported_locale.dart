enum SupportedLocale { ru, en, kk }

SupportedLocale getSupportedLocale(String locale) {
  switch (locale) {
    case 'en':
      return SupportedLocale.en;
    case 'kk':
      return SupportedLocale.kk;
    case 'ru':
      return SupportedLocale.ru;
    default:
      return SupportedLocale.ru; // default language
  }
}
