import '../domain/entities/user.dart';
import '../domain/repositories/user_repository.dart';
import 'mock_data.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<User> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.currentUser;
  }

  @override
  Future<User> updateProfile({String? firstName, String? lastName, String? phone}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.currentUser;
  }

  @override
  Future<void> updateCompanyInfo({required String companyName, String? address, String? taxId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
