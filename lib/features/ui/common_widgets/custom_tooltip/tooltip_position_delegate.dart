import 'package:flutter/material.dart';

import 'tooltip_enums.dart';
import 'tooltip_utils.dart';

class TooltipPositionDelegate extends SingleChildLayoutDelegate {
  TooltipPositionDelegate({
    required this.preferredDirection,
    required this.constraints,
    required this.margin,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.target,
    required this.overlay,
  });

  // TD: Make this EdgeInsets
  final double margin;
  final Offset target;
  final RenderBox? overlay;
  final BoxConstraints constraints;

  final TooltipDirection preferredDirection;
  final double? top, bottom, left, right;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // TD: when margin is EdgeInsets, look into
    // constraints.deflate(margin);

    var newConstraints = constraints;

    switch (preferredDirection) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        newConstraints = CustomTooltipUtils.verticalConstraints(
          constraints: newConstraints,
          margin: margin,
          bottom: bottom,
          isUp: preferredDirection == TooltipDirection.up,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
      case TooltipDirection.right:
      case TooltipDirection.left:
        newConstraints = CustomTooltipUtils.horizontalConstraints(
          constraints: newConstraints,
          margin: margin,
          bottom: bottom,
          isRight: preferredDirection == TooltipDirection.right,
          target: target,
          top: top,
          left: left,
          right: right,
        );
        break;
    }

    // TD: This scenerio should likely be avoided in the initial functions
    return newConstraints.copyWith(
      minHeight: newConstraints.minHeight > newConstraints.maxHeight
          ? newConstraints.maxHeight
          : newConstraints.minHeight,
      minWidth: newConstraints.minWidth > newConstraints.maxWidth
          ? newConstraints.maxWidth
          : newConstraints.minWidth,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    switch (preferredDirection) {
      case TooltipDirection.up:
      case TooltipDirection.down:
        final topOffset = preferredDirection == TooltipDirection.up
            ? top ?? target.dy - childSize.height
            : target.dy;

        return Offset(
          CustomTooltipUtils.leftMostXtoTarget(
            childSize: childSize,
            left: left,
            margin: margin,
            right: right,
            size: size,
            target: target,
          ),
          topOffset,
        );

      case TooltipDirection.right:
      case TooltipDirection.left:
        final leftOffset = preferredDirection == TooltipDirection.left
            ? left ?? target.dx - childSize.width
            : target.dx;
        return Offset(
          leftOffset,
          CustomTooltipUtils.topMostYtoTarget(
            bottom: bottom,
            childSize: childSize,
            margin: margin,
            size: size,
            target: target,
            top: top,
          ),
        );
      default:
        throw ArgumentError(preferredDirection);
    }
  }

  @override
  bool shouldRelayout(TooltipPositionDelegate oldDelegate) => true;
}
