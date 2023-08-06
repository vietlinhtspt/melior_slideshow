part of 'melior_slider.dart';

mixin MeliorSlideshowMixin {
  var _indexedSlidesStack = <int>[];
  late StreamController<double> _changingRatioStream;

  int hello = 1;

  List<int> _genIndexes({
    required int numOfVisibleSlide,
    required int maxSlide,
  }) {
    final maxElement =
        numOfVisibleSlide > maxSlide ? maxSlide : numOfVisibleSlide;
    return List.generate(
      maxElement,
      (index) => index,
    );
  }

  int _getNextIndexedSlide({
    required List<int> currentStack,
    required int maxSlide,
  }) {
    final lastIndexedSlide = currentStack.last;
    late int nextIndex;
    if (lastIndexedSlide >= maxSlide - 1) {
      nextIndex = 0;
    } else {
      nextIndex = lastIndexedSlide + 1;
    }
    return nextIndex;
  }

  _onDeleteItem(
    int index,
    int maxSlide,
    bool mounted,
    void Function(void Function() fn) setState,
  ) {
    _indexedSlidesStack.firstWhere((element) => element == index);

    _indexedSlidesStack.removeWhere((element) => element == index);

    _indexedSlidesStack.add(
      _getNextIndexedSlide(
        currentStack: _indexedSlidesStack,
        maxSlide: maxSlide,
      ),
    );
    if (mounted) setState(() {});
  }
}
