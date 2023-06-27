
import 'aijiaplugin_platform_interface.dart';

class Aijiaplugin {
  Future<String?> getPlatformVersion() {
    return AijiapluginPlatform.instance.getPlatformVersion();
  }
}
