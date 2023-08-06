import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'melior_slider_method_channel.dart';

abstract class MeliorSliderPlatform extends PlatformInterface {
  /// Constructs a MeliorSliderPlatform.
  MeliorSliderPlatform() : super(token: _token);

  static final Object _token = Object();

  static MeliorSliderPlatform _instance = MethodChannelMeliorSlider();

  /// The default instance of [MeliorSliderPlatform] to use.
  ///
  /// Defaults to [MethodChannelMeliorSlider].
  static MeliorSliderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MeliorSliderPlatform] when
  /// they register themselves.
  static set instance(MeliorSliderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
