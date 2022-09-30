import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melior_slider/melior_slider_method_channel.dart';

void main() {
  MethodChannelMeliorSlider platform = MethodChannelMeliorSlider();
  const MethodChannel channel = MethodChannel('melior_slider');

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
