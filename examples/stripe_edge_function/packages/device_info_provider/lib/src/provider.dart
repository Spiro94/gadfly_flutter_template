import 'package:device_info_plus/device_info_plus.dart';

/// {@template deviceInfoProvider.provider}
/// A provider that wraps device info plus
/// {@endtemplate}
class DeviceInfoProvider {
  /// {@macro deviceInfoProvider.provider}
  const DeviceInfoProvider({
    required this.deviceInfoPlugin,
  });

  /// A reference to the [DeviceInfoPlugin]
  final DeviceInfoPlugin deviceInfoPlugin;

  /// get device information
  Future<Map<String, String?>> getDeviceInfo({
    required bool isIOS,
  }) async {
    final deviceInfo = <String, String?>{};

    if (isIOS) {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;

      deviceInfo.addAll({
        'isPhysicalDevice': '${iosDeviceInfo.isPhysicalDevice}',
        'localizedModel': iosDeviceInfo.localizedModel,
        'model': iosDeviceInfo.model,
        'name': iosDeviceInfo.name,
        'systemName': iosDeviceInfo.systemName,
        'systemVersion': iosDeviceInfo.systemVersion,
        'utsnameMachine': iosDeviceInfo.utsname.machine,
        'utsnameRelease': iosDeviceInfo.utsname.release,
        'utsnameSysname': iosDeviceInfo.utsname.sysname,
        'utsnameVersion': iosDeviceInfo.utsname.version,
      });
    } else {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo.addAll({
        'board': androidDeviceInfo.board,
        'bootloader': androidDeviceInfo.bootloader,
        'brand': androidDeviceInfo.brand,
        'device': androidDeviceInfo.device,
        'display': androidDeviceInfo.display,
        'displayMetricsHeightInches':
            androidDeviceInfo.displayMetrics.heightInches.toString(),
        'displayMetricsHeightPx':
            androidDeviceInfo.displayMetrics.heightPx.toString(),
        'displayMetricsSizeInches':
            androidDeviceInfo.displayMetrics.sizeInches.toString(),
        'displayMetricsWidthInches':
            androidDeviceInfo.displayMetrics.widthInches.toString(),
        'displayMetricsWidthPx':
            androidDeviceInfo.displayMetrics.widthPx.toString(),
        'displayMetricsXDpi': androidDeviceInfo.displayMetrics.xDpi.toString(),
        'displayMetricsYDpi': androidDeviceInfo.displayMetrics.yDpi.toString(),
        'fingerprint': androidDeviceInfo.fingerprint,
        'hardware': androidDeviceInfo.hardware,
        'host': androidDeviceInfo.host,
        'isPhysicalDevice': '${androidDeviceInfo.isPhysicalDevice}',
        'manufacturer': androidDeviceInfo.manufacturer,
        'model': androidDeviceInfo.model,
        'product': androidDeviceInfo.product,
        'serialNumber': androidDeviceInfo.serialNumber,
        'supported32BitAbis': androidDeviceInfo.supported32BitAbis.join(','),
        'supported64BitAbis': androidDeviceInfo.supported64BitAbis.join(','),
        'supportedAbis': androidDeviceInfo.supportedAbis.join(','),
        'systemFeatures': androidDeviceInfo.systemFeatures.join(','),
        'tags': androidDeviceInfo.tags,
        'type': androidDeviceInfo.type,
        'versionBaseOS': androidDeviceInfo.version.baseOS,
        'versionCodename': androidDeviceInfo.version.codename,
        'versionIncremental': androidDeviceInfo.version.incremental,
        'versionPreviewSdkInt':
            androidDeviceInfo.version.previewSdkInt.toString(),
        'versionRelease': androidDeviceInfo.version.release,
        'versionSdkInt': androidDeviceInfo.version.sdkInt.toString(),
        'versionSecurityPatch': androidDeviceInfo.version.securityPatch,
      });
    }
    return deviceInfo;
  }
}
