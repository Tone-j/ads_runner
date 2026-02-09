import '../core/enums/screen_status.dart';
import '../domain/entities/screen_device.dart';
import '../domain/repositories/screen_repository.dart';
import 'mock_data.dart';

class MockScreenRepository implements ScreenRepository {
  @override
  Future<List<ScreenDevice>> getScreens({int page = 1, ScreenStatus? status, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var results = MockData.screens;
    if (status != null) results = results.where((s) => s.status == status).toList();
    if (query != null && query.isNotEmpty) {
      results = results.where((s) => s.name.toLowerCase().contains(query.toLowerCase()) || s.vehiclePlate.toLowerCase().contains(query.toLowerCase())).toList();
    }
    return results;
  }

  @override
  Future<ScreenDevice> getScreenById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.screens.firstWhere((s) => s.id == id, orElse: () => MockData.screens.first);
  }
}
