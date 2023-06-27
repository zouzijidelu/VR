import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aijiaplugin/aijiaplugin_method_channel.dart';

void main() {
  MethodChannelAijiaplugin platform = MethodChannelAijiaplugin();
  const MethodChannel channel = MethodChannel('aijiaplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
