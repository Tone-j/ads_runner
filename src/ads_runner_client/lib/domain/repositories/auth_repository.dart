import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String companyName,
    required String password,
  });
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> get isAuthenticated;
}
