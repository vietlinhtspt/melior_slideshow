import 'package:flutter/material.dart';
import 'package:melior_slider/melior_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: HomeScreen(items: _items),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required List<String> items,
  })  : _items = items,
        super(key: key);

  final List<String> _items;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = MediaQuery.of(context).size.height * 2 / 3 > 400.0
        ? 400.0
        : MediaQuery.of(context).size.height * 2 / 3;
    final cardHeight = cardWidth / 2;

    return Scaffold(
      body: Stack(
        children: [
          MeliorSlider(
            maxSlide: _items.length,
            numOfVisibleSlide: 3,
            initialOffset: Offset((screenWidth - cardWidth) / 2, 100),
            deltaOffset: const Offset(20, 20),
            autoJump: true,
            onBuildChild: ((
              currentElevationIndex,
              index,
            ) {
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
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
          MeliorSlider(
            maxSlide: _items.length,
            numOfVisibleSlide: 5,
            initialOffset: Offset((screenWidth - cardWidth) / 2, 400),
            deltaOffset: const Offset(20, 20),
            autoJump: false,
            onBuildChild: ((
              currentElevationIndex,
              index,
            ) {
              final currentWidth = cardWidth - currentElevationIndex * 20 * 2;
              return SizedBox(
                width: currentWidth,
                height: cardHeight,
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
    );
  }
}
