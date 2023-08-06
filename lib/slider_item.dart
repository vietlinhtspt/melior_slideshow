import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SliderItem extends StatefulWidget {
  const SliderItem({
    Key? key,
    required this.elevationIndex,
    required this.onDeleteItem,
    required this.index,
    required this.onMoving,
    required this.onBuildChild,
    required this.initialOffset,
    required this.deltaOffset,
    required this.changingRatioStream,
    this.duration = 100,
    required this.autoJump,
    this.jumpingEndLocation,
    required this.autoJumnDuration,
  }) : super(key: key);

  final int elevationIndex;
  final Function(int index) onDeleteItem;
  final int index;
  final Function(Offset offset) onMoving;
  final Widget Function(
    int currentElevationIndex,
    int index,
  ) onBuildChild;
  final Offset initialOffset;
  final Offset deltaOffset;
  final StreamController<double> changingRatioStream;
  final int duration;
  final bool autoJump;
  final Offset? jumpingEndLocation;
  final Duration autoJumnDuration;

  @override
  State<SliderItem> createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> with TickerProviderStateMixin {
  late double _topPosition;
  late double _leftPosition;
  late double _initialTopPosition;
  late double _initialLeftPosition;
  bool _onMoving = false;
  final _rotateAngle = math.pi / 10;

  final _childGlobalKey = GlobalKey();

  @override
  void initState() {
    _initialTopPosition =
        widget.elevationIndex * widget.deltaOffset.dy + widget.initialOffset.dy;
    _initialLeftPosition =
        widget.elevationIndex * widget.deltaOffset.dx + widget.initialOffset.dx;
    _topPosition = _initialTopPosition;
    _leftPosition = _initialLeftPosition;

    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _checkAndStartAutoJump();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.changingRatioStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && widget.elevationIndex != 0) {
            _topPosition =
                _initialTopPosition - widget.deltaOffset.dy * snapshot.data!;
            _leftPosition =
                _initialLeftPosition - widget.deltaOffset.dx * snapshot.data!;
          }

          return AnimatedPositioned(
            duration: Duration(milliseconds: widget.duration),
            top: _topPosition,
            left: _leftPosition,
            child: Listener(
              onPointerMove: (event) {
                if (widget.elevationIndex == 0) {
                  _topPosition += event.delta.dy;
                  _leftPosition += event.delta.dx;
                  widget.onMoving(Offset(
                    _leftPosition - _initialLeftPosition,
                    _topPosition - _initialTopPosition,
                  ));

                  _onMoving = true;
                  if (mounted) setState(() {});
                }
              },
              onPointerUp: (event) async {
                if ((_topPosition - _initialTopPosition).abs() >
                        widget.deltaOffset.dy ||
                    (_leftPosition - _initialLeftPosition).abs() >
                        widget.deltaOffset.dx) {
                  final endPosition = _calEndPosition();
                  await _removingAnimation(endPosition);
                } else {
                  _topPosition = _initialTopPosition;
                  _leftPosition = _initialLeftPosition;
                }

                _onMoving = false;

                // _checkAndStartAutoJump();

                if (mounted) setState(() {});
              },
              child: AnimatedRotation(
                key: UniqueKey(),
                duration: Duration(milliseconds: widget.duration),
                turns: _onMoving
                    ? !_chidWidgetRotation.isNaN
                        ? _chidWidgetRotation
                        : 0
                    : 0,
                child: SizedBox(
                  key: _childGlobalKey,
                  child: widget.onBuildChild(
                    widget.elevationIndex,
                    widget.index,
                  ),
                ),
              ),
            ),
          );
        });
  }

  double get _chidWidgetRotation =>
      ((_leftPosition / MediaQuery.of(context).size.width * 2 +
                  _topPosition / MediaQuery.of(context).size.height * 2)
              .abs() -
          0.5) *
      _rotateAngle /
      math.pi /
      6;

  int _calCurrentLocationSurface() {
    // 0 | 1
    //-------
    // 2 | 3
    final topLocationCode = _topPosition > _initialTopPosition ? 1 : 0;
    final leftLocationCode = _leftPosition > _initialLeftPosition ? 1 : 0;
    return topLocationCode * 2 + leftLocationCode;
  }

  Offset _calEndPosition() {
    // 0 | 1
    //-------
    // 2 | 3
    final surfaceLocation = _calCurrentLocationSurface();
    late double endTopPosition;
    late double endLeftPosition;

    final currentWidgetHeight =
        (_childGlobalKey.currentContext?.size?.height ?? 0);
    final currentWidgetWidth =
        (_childGlobalKey.currentContext?.size?.width ?? 0);

    if (surfaceLocation == 0 || surfaceLocation == 1) {
      endTopPosition =
          currentWidgetHeight * -1 * (1 + math.sin(_rotateAngle) * 2);
    } else {
      endTopPosition = MediaQuery.of(context).size.height +
          math.sin(_rotateAngle) * currentWidgetHeight * 2;
    }

    if (surfaceLocation == 0 || surfaceLocation == 2) {
      endLeftPosition = currentWidgetWidth * -1;
    } else {
      endLeftPosition = MediaQuery.of(context).size.width;
    }
    return Offset(endLeftPosition, endTopPosition);
  }

  Offset get _defaultEndPosition {
    final currentWidgetHeight =
        (_childGlobalKey.currentContext?.size?.height ?? 0);
    final currentWidgetWidth =
        (_childGlobalKey.currentContext?.size?.width ?? 0);

    return Offset(
      currentWidgetWidth * -1,
      currentWidgetHeight * -1 * (1 + math.sin(_rotateAngle) * 2),
    );
  }

  bool _isTopPositionOnSurface(double dy) {
    return (dy.abs() > _topPosition.abs());
  }

  bool _isLeftPositionOnSurface(double dx) {
    return (dx.abs() > _leftPosition.abs());
  }

  Future _removingAnimation(Offset endPosition) async {
    _onMoving = true;
    while (_isTopPositionOnSurface(endPosition.dy) ||
        _isLeftPositionOnSurface(endPosition.dx)) {
      if (_isTopPositionOnSurface(endPosition.dy)) {
        double topPositionDelta = (endPosition.dy - _topPosition) / 5;
        topPositionDelta = topPositionDelta > 100
            ? topPositionDelta
            : 100 * topPositionDelta / topPositionDelta.abs();
        _topPosition += topPositionDelta;
      }

      if (_isLeftPositionOnSurface(endPosition.dx)) {
        double leftPositionDelta = (endPosition.dx - _leftPosition) / 5;

        leftPositionDelta = leftPositionDelta > 100
            ? leftPositionDelta
            : 100 * leftPositionDelta / leftPositionDelta.abs();

        _leftPosition += leftPositionDelta;
      }

      widget.onMoving(Offset(
        _leftPosition - _initialLeftPosition,
        _topPosition - _initialTopPosition,
      ));

      if (mounted) setState(() {});
      await Future.delayed(Duration(
        milliseconds: widget.duration,
      ));
    }
    _onMoving = false;
    widget.onDeleteItem(widget.index);
  }

  bool _checkAndStartAutoJump() {
    var isAutoJump = false;
    if (widget.autoJump) {
      isAutoJump = true;
      Future.delayed(widget.autoJumnDuration).then((value) {
        if (!_onMoving && mounted) {
          final endPosition = widget.jumpingEndLocation ?? _defaultEndPosition;

          _removingAnimation(endPosition);
        }
      });
    }

    return isAutoJump;
  }
}
