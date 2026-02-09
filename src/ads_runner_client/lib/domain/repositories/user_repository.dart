import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getProfile();
  Future<User> updateProfile({String? firstName, String? lastName, String? phone});
  Future<void> updateCompanyInfo({required String companyName, String? address, String? taxId});
}
