class AppUrl {
  static const String liveBaseURL = "https://login_signup_app/api/v1";
  static const String localBaseURL = "http://10.0.2.2:4000/api/v1";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/session";
  static const String register = baseURL + "/registration";
  static const String forgotPassword = baseURL + "/forgot-password";
}
