# melior_slideshow


A Flutter plugin for create beautiful slideshows.
Supports Android, iOS and Web.

|                    | Android | iOS  | Web | macOS | Window | Linux|
|-------------------| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Support** | SDK 16+ | 9.0+ | Any | ❌️ | ❌️ | ❌️ |

## Usage

To use this plugin, add `melior_slideshow` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

## Example
```dart
MeliorSlider(
              maxSlide: _items.length,
              numOfVisibleSlide: 3,
              initialOffset: const Offset(100, 100),
              deltaOffset: const Offset(20, 20),
              autoJump: true,
              onBuildChild: (({int currentElevationIndex = 0, int index = 0}) {
                return SizedBox(
                  width: 400,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _items[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
```

## Functions

Functions support by platform:

| Function | Android | iOS | Linux | macOS | Windows | Web |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Create slider | ✔️ | ✔️ | ✔️ | ❌️ | ❌️| ✔️ |
| Auto next  | ❌️ | ❌️ | ❌️ | ❌️ | ❌️ | ❌️ |


## Testing

See this `melior_slideshow` [test]() for an example.
 