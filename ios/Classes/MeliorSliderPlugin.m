#import "MeliorSliderPlugin.h"
#if __has_include(<melior_slider/melior_slider-Swift.h>)
#import <melior_slider/melior_slider-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "melior_slider-Swift.h"
#endif

@implementation MeliorSliderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMeliorSliderPlugin registerWithRegistrar:registrar];
}
@end
