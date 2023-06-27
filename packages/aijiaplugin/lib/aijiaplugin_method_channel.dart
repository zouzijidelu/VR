import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aijiaplugin_platform_interface.dart';

/// An implementation of [AijiapluginPlatform] that uses method channels.
class MethodChannelAijiaplugin extends AijiapluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('aijiaplugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
