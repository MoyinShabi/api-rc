class Env {
  static String get accessKey => const String.fromEnvironment('ACCESS_KEY');
  static String get unsplashBaseUrl =>
      const String.fromEnvironment('UNSPLASH_BASE_URL');
  static String get mockapiBaseUrl =>
      const String.fromEnvironment('MOCKAPI_BASE_URL');
}
