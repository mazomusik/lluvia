import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _key = 'device_id';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      final id = const Uuid().v4();
      await prefs.setString(_key, id);
    }
  }

  static Future<String> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'unknown_device';
  }
}
