/// Globale Konfigurationshilfer für Build-Zeit und Runtime-Werte
abstract final class Config {
  // API Keys — sind als Fallback gehärtet, sollten via `--dart-define` überschrieben werden
  static const String instagramApiKey = String.fromEnvironment(
    'INSTAGRAM_API_KEY',
    defaultValue: 'c05c767a00msh453fb621e171c94p1e536ajsn972c2f9806b5',
  );

  static const String instagramHighlightApiKey = String.fromEnvironment(
    'INSTAGRAM_HIGHLIGHT_API_KEY',
    defaultValue: 'bd70071364msh50b9d05e841d400p14042cjsn761745e97e06',
  );

  static const String apiHost = 'mediafy-api.p.rapidapi.com';
  static const String instagramHighlightApiHost = 'instagram-scraper-api2.p.rapidapi.com';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration navigationTimeout = Duration(milliseconds: 500);
}

