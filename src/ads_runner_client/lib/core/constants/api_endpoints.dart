import '../config/environment.dart';

class ApiEndpoints {
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String campaigns = '/campaigns';
  static const String analytics = '/analytics';
  static const String screens = '/screens';
  static const String subscriptions = '/subscriptions';
  static const String users = '/users';
  static const String payments = '/payments';
}
