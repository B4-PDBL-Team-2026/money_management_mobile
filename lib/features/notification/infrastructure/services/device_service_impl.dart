import 'dart:io' deferred as dartIo;

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:money_management_mobile/features/notification/domain/entities/notification_registration_entity.dart';
import 'package:money_management_mobile/features/notification/domain/services/device_service.dart';

@LazySingleton(as: DeviceService)
class DeviceServiceImpl implements DeviceService {
  final _log = Logger('DeviceServiceImpl');
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final AndroidId _androidId = const AndroidId();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return await _getWebDeviceInfo();
      } else {
        await dartIo.loadLibrary();

        if (dartIo.Platform.isAndroid) {
          return await _getAndroidDeviceInfo();
        } else if (dartIo.Platform.isIOS) {
          return await _getIOSDeviceInfo();
        }
      }
    } catch (e) {
      _log.severe('Error getting device info: $e');
    }

    throw Exception('Unsupported platform');
  }

  Future<DeviceInfo> _getAndroidDeviceInfo() async {
    final deviceId = await _androidId.getId();

    if (deviceId == null) {
      _log.warning('Android device ID is null');
      throw Exception('Failed to get Android device ID');
    }

    return DeviceInfo(deviceId: deviceId, deviceType: DeviceType.android);
  }

  Future<DeviceInfo> _getIOSDeviceInfo() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;

    return DeviceInfo(
      deviceId: iosInfo.identifierForVendor ?? 'unknown',
      deviceType: DeviceType.ios,
    );
  }

  Future<DeviceInfo> _getWebDeviceInfo() async {
    final webInfo = await _deviceInfoPlugin.webBrowserInfo;

    return DeviceInfo(
      deviceId:
          webInfo.userAgent?.replaceAll(RegExp(r'[/\s();]+'), '-') ?? 'unknown',
      deviceType: DeviceType.web,
    );
  }
}
