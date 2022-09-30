import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'melior_slider_platform_interface.dart';

/// An implementation of [MeliorSliderPlatform] that uses method channels.
class MethodChannelMeliorSlider extends MeliorSliderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('melior_slider');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
