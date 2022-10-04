import 'package:flutter/material.dart';
import 'package:melior_slider/melior_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _items = [
    'assets/leesin_01.jpeg',
    'assets/leesin_02.jpeg',
    'assets/leesin_03.jpg',
    'assets/leesin_04.jpeg',
    'assets/leesin_05.jpeg'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }
}
