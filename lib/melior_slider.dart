import 'dart:async';
import 'package:flutter/material.dart';

import 'slider_item.dart';

part 'melior_slideshow_mixin.dart';

class MeliorSlider extends StatefulWidget {
  final double? width;
  final double? height;
  final int numOfVisibleSlide;
  final int maxSlide;
  final Widget Function(
    int currentElevationIndex,
    int index,
  ) onBuildChild;
  final Offset initialOffset;
  final Offset deltaOffset;
  final int duration = 100;
  final bool autoJump;
  final Duration autoJumnDuration;
  final Offset? jumpingEndLocation;

  const MeliorSlider({
    super.key,
    this.width,
    this.height,
    required this.maxSlide,
    this.numOfVisibleSlide = 5,
    required this.onBuildChild,
    this.initialOffset = const Offset(0, 0),
    this.deltaOffset = const Offset(0, 0),
    this.autoJump = false,
    this.autoJumnDuration = const Duration(seconds: 5),
    this.jumpingEndLocation,
  });

  @override
  State<MeliorSlider> createState() => _MeliorSliderState();
}

class _MeliorSliderState extends State<MeliorSlider> with MeliorSlideshowMixin {
  @override
  void initState() {
    _indexedSlidesStack = _genIndexes(
      numOfVisibleSlide: widget.numOfVisibleSlide,
      maxSlide: widget.maxSlide,
    );
    _changingRatioStream = StreamController<double>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _changingRatioStream.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MeliorSlider oldWidget) {
    _indexedSlidesStack = _genIndexes(
      numOfVisibleSlide: widget.numOfVisibleSlide,
      maxSlide: widget.maxSlide,
    );
    if (mounted) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: _indexedSlidesStack
            .asMap()
            .entries
            .toList()
            .map(
              (item) => SliderItem(
                key: UniqueKey(),
                elevationIndex: item.key,
                index: item.value,
                initialOffset: widget.initialOffset,
                deltaOffset: widget.deltaOffset,
                changingRatioStream: _changingRatioStream,
                duration: widget.duration,
                autoJump: widget.autoJump && item.key == 0,
                autoJumnDuration: widget.autoJumnDuration,
                jumpingEndLocation: widget.jumpingEndLocation,
                onDeleteItem: (index) => _onDeleteItem(
                  index,
                  widget.maxSlide,
                  mounted,
                  setState,
                ),
                onMoving: (offset) {
                  double changingRatio =
                      offset.distance / widget.initialOffset.distance;
                  if (changingRatio > 1) {
                    changingRatio = 1;
                  }
                  _changingRatioStream.add(changingRatio);
                },
                onBuildChild: widget.onBuildChild,
              ),
            )
            .toList()
            .reversed
            .toList(),
      ),
    );
  }
}

class MeliorSlideshowCross extends MeliorSlider {
  const MeliorSlideshowCross({
    super.key,
    required super.maxSlide,
    required super.onBuildChild,
  });

  Widget build(BuildContext context) {
    return Container();
  }
}

class MeliorSlideshowTopCenter {}
