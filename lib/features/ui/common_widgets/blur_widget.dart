import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    super.key,
    required this.child,
  }) : _isGreyscale = false;

  const BlurWidget.greyscale({
    super.key,
    required this.child,
  }) : _isGreyscale = true;

  final Widget child;
  final bool _isGreyscale;

  @override
  Widget build(BuildContext context) =>
      _isGreyscale ? _GreyscaleBlur(child) : _DefaultBlur(child);
}

class _DefaultBlur extends StatelessWidget {
  const _DefaultBlur(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: AbsorbPointer(child: child),
      ),
    );
  }
}

class _GreyscaleBlur extends StatelessWidget {
  const _GreyscaleBlur(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126, 0.7152, 0.0722, 0, 0, //
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: AbsorbPointer(child: child),
        ),
      ),
    );
  }
}
