import 'package:flutter_test/flutter_test.dart';
import 'package:aijiaplugin/aijiaplugin.dart';
import 'package:aijiaplugin/aijiaplugin_platform_interface.dart';
import 'package:aijiaplugin/aijiaplugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAijiapluginPlatform
    with MockPlatformInterfaceMixin
    implements AijiapluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AijiapluginPlatform initialPlatform = AijiapluginPlatform.instance;

  test('$MethodChannelAijiaplugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAijiaplugin>());
  });

  test('getPlatformVersion', () async {
    Aijiaplugin aijiapluginPlugin = Aijiaplugin();
    MockAijiapluginPlatform fakePlatform = MockAijiapluginPlatform();
    AijiapluginPlatform.instance = fakePlatform;

    expect(await aijiapluginPlugin.getPlatformVersion(), '42');
  });
}
