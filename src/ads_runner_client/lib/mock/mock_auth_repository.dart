import '../core/enums/user_role.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
import 'mock_data.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    _currentUser = MockData.currentUser;
    return _currentUser!;
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String companyName,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = User(
      id: 'usr_new',
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: UserRole.client,
      companyName: companyName,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async => _currentUser;

  @override
  Future<bool> get isAuthenticated async => _currentUser != null;
}
