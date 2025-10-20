import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:uuid/uuid.dart';

class DeviceId {
  static FlutterSecureStorage? storage;
  static String key = "delta_innvie_SessionId_Key";
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static Future<String> create() async {
    initialize();
    String? deviceId = await storage!.read(key: key);

    if (deviceId == null) {
      // Tạo một Device ID mới
      deviceId = const Uuid().v4(); // UUID ngẫu nhiên
      await storage!.write(key: key, value: deviceId);
    }
    return deviceId;
  }

  static Future<String> get() async {
    if (PlatformCheck.isAndroid) {
      return await getAndroidId() ?? "";
    } else {
      try {
        initialize();
        String? result = await storage!.read(key: key);
        if (result != null) {
          return result;
        } else {
          return await create();
        }
      } catch (e) {
        return '';
      }
    }
  }

  static initialize() {
    if (storage != null) {
      return;
    }
    if (PlatformCheck.isAndroid) {
      storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    } else {
      storage = const FlutterSecureStorage();
    }
  }

  static Future<String?> getAndroidId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // ANDROID_ID
  }
}
