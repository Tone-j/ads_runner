import '../entities/screen_device.dart';
import '../../core/enums/screen_status.dart';

abstract class ScreenRepository {
  Future<List<ScreenDevice>> getScreens({int page = 1, ScreenStatus? status, String? query});
  Future<ScreenDevice> getScreenById(String id);
}
