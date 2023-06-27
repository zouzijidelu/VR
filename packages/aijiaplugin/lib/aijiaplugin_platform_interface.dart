import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aijiaplugin_method_channel.dart';

abstract class AijiapluginPlatform extends PlatformInterface {
  /// Constructs a AijiapluginPlatform.
  AijiapluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AijiapluginPlatform _instance = MethodChannelAijiaplugin();

  /// The default instance of [AijiapluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAijiaplugin].
  static AijiapluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AijiapluginPlatform] when
  /// they register themselves.
  static set instance(AijiapluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
