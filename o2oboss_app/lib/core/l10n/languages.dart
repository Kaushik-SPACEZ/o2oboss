/// Languages offered in the app: English plus the 22 scheduled languages of
/// India. Pure Dart (no Flutter import) so tool scripts can use it too.
library;

class AppLanguage {
  const AppLanguage(
    this.code,
    this.endonym,
    this.englishName, {
    this.rtl = false,
    this.fallback,
  });

  final String code;

  /// The language's name in its own script — shown in the language picker.
  final String endonym;
  final String englishName;
  final bool rtl;

  /// Closest language that Flutter's built-in widgets (date pickers, etc.)
  /// support, used when this one isn't supported directly.
  final String? fallback;
}

const appLanguages = <AppLanguage>[
  AppLanguage('en', 'English', 'English'),
  AppLanguage('hi', 'हिन्दी', 'Hindi'),
  AppLanguage('ta', 'தமிழ்', 'Tamil'),
  AppLanguage('te', 'తెలుగు', 'Telugu'),
  AppLanguage('kn', 'ಕನ್ನಡ', 'Kannada'),
  AppLanguage('ml', 'മലയാളം', 'Malayalam'),
  AppLanguage('bn', 'বাংলা', 'Bengali'),
  AppLanguage('mr', 'मराठी', 'Marathi'),
  AppLanguage('gu', 'ગુજરાતી', 'Gujarati'),
  AppLanguage('pa', 'ਪੰਜਾਬੀ', 'Punjabi'),
  AppLanguage('or', 'ଓଡ଼ିଆ', 'Odia'),
  AppLanguage('as', 'অসমীয়া', 'Assamese'),
  AppLanguage('ur', 'اردو', 'Urdu', rtl: true),
  AppLanguage('ne', 'नेपाली', 'Nepali'),
  AppLanguage('kok', 'कोंकणी', 'Konkani', fallback: 'hi'),
  AppLanguage('mai', 'मैथिली', 'Maithili', fallback: 'hi'),
  AppLanguage('doi', 'डोगरी', 'Dogri', fallback: 'hi'),
  AppLanguage('brx', 'बड़ो', 'Bodo', fallback: 'hi'),
  AppLanguage('sa', 'संस्कृतम्', 'Sanskrit', fallback: 'hi'),
  AppLanguage('ks', 'کٲشُر', 'Kashmiri', rtl: true, fallback: 'ur'),
  AppLanguage('sd', 'سنڌي', 'Sindhi', rtl: true, fallback: 'ur'),
  AppLanguage('mni', 'ꯃꯤꯇꯩꯂꯣꯟ', 'Manipuri', fallback: 'bn'),
  AppLanguage('sat', 'ᱥᱟᱱᱛᱟᱲᱤ', 'Santali', fallback: 'en'),
];

AppLanguage? languageFor(String code) {
  for (final l in appLanguages) {
    if (l.code == code) return l;
  }
  return null;
}
