import 'package:flutter/material.dart';
import 'package:new_project_template/util/consts.dart';

import 'tooltip_shape.dart';
import 'tooltip_enums.dart';
import 'tooltip_controller.dart';
import 'tooltip_position_delegate.dart';
import 'tooltip_utils.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    required this.content,
    required this.controller,
    this.popupDirection = TooltipDirection.down,
    this.onLongPress,
    this.onShow,
    this.onHide,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.minimumOutsideMargin = 20.0,
    this.verticalOffset = 0.0,
    this.elevation = 0.0,
    this.backgroundColor,
    this.decoration,
    this.child,
    this.constraints = const BoxConstraints(
      minHeight: 0.0,
      maxHeight: double.infinity,
      minWidth: 0.0,
      maxWidth: double.infinity,
    ),
    this.arrowLength = 20.0,
    this.arrowBaseWidth = 20.0,
    this.arrowTipDistance = 2.0,
    this.borderRadius = 10.0,
    this.overlayDimensions = const EdgeInsets.all(10),
    this.bubbleDimensions = const EdgeInsets.all(10),
    this.hideTooltipOnTap = false,
    this.shadows = const [],
  });

  final Widget content;
  final TooltipDirection popupDirection;
  final TooltipController controller;
  final void Function()? onLongPress;
  final void Function()? onShow;
  final void Function()? onHide;

  final double? top, right, bottom, left;
  final double minimumOutsideMargin;
  final double verticalOffset;
  final Widget? child;
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final Decoration? decoration;
  final double elevation;
  final double arrowLength;
  final double arrowBaseWidth;
  final double arrowTipDistance;
  final double borderRadius;

  final EdgeInsetsGeometry overlayDimensions;
  final EdgeInsetsGeometry bubbleDimensions;
  final bool hideTooltipOnTap;

  final List<BoxShadow> shadows;

  @override
  State createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  TooltipController? _tooltipController;
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: duration_200ms,
      vsync: this,
    );
    _tooltipController = widget.controller;
    _tooltipController!.addListener(_onChangeNotifier);
  }

  @override
  void didUpdateWidget(CustomTooltip oldWidget) {
    if (_tooltipController != widget.controller) {
      _tooltipController!.removeListener(_onChangeNotifier);
      _tooltipController = widget.controller;
      _tooltipController!.addListener(_onChangeNotifier);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_entry != null) _removeEntries();
    _tooltipController?.removeListener(_onChangeNotifier);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _tooltipController!.showTooltip,
        onLongPress: widget.onLongPress,
        child: widget.child,
      ),
    );
  }

  void _onChangeNotifier() {
    switch (_tooltipController!.event) {
      case Event.show:
        _showTooltip();
        break;
      case Event.hide:
        _hideTooltip();
        break;
    }
  }

  void _createOverlayEntries() {
    final renderBox = context.findRenderObject() as RenderBox;

    final overlayState = Overlay.of(context);
    RenderBox? overlay;

    overlay = overlayState.context.findRenderObject() as RenderBox?;

    final size = renderBox.size;
    final target = renderBox.localToGlobal(size.center(Offset.zero));
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    final offsetToTarget = Offset(
      -target.dx + size.width / 2,
      -target.dy + size.height / 2,
    );

    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).cardColor;

    var constraints = widget.constraints;
    var preferredDirection = widget.popupDirection;
    var left = widget.left;
    var right = widget.right;
    var top = widget.top;
    var bottom = widget.bottom;

    _entry = OverlayEntry(
      builder: (context) => FadeTransition(
        opacity: animation,
        child: Center(
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: offsetToTarget,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) {
                _tooltipController!.hideTooltip();
              },
              child: CustomSingleChildLayout(
                delegate: TooltipPositionDelegate(
                  preferredDirection: preferredDirection,
                  constraints: constraints,
                  top: top,
                  bottom: bottom,
                  left: left,
                  right: right,
                  target: target,
                  // verticalOffset: widget.verticalOffset,
                  overlay: overlay,
                  margin: widget.minimumOutsideMargin,
                ),
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.hideTooltipOnTap) {
                        _tooltipController!.hideTooltip();
                      }
                    },
                    child: Container(
                      margin: CustomTooltipUtils.getTooltipMargin(
                        arrowLength: widget.arrowLength,
                        arrowTipDistance: widget.arrowTipDistance,
                        preferredDirection: preferredDirection,
                      ),
                      decoration: widget.decoration ??
                          ShapeDecoration(
                            color: backgroundColor,
                            shadows: widget.shadows,
                            shape: BubbleShape(
                              target: target,
                              preferredDirection: preferredDirection,
                              bubbleDimensions: widget.bubbleDimensions,
                              borderRadius: widget.borderRadius,
                              arrowBaseWidth: widget.arrowBaseWidth,
                              arrowTipDistance: widget.arrowTipDistance,
                              top: top,
                              bottom: bottom,
                              left: left,
                              right: right,
                            ),
                          ),
                      child: widget.content,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_entry!);
  }

  _showTooltip() async {
    widget.onShow?.call();

    if (_entry != null) return;

    _createOverlayEntries();

    await _animationController
        .forward()
        .whenComplete(_tooltipController!.complete);
  }

  _removeEntries() {
    _entry?.remove();
    _entry = null;
  }

  _hideTooltip() async {
    widget.onHide?.call();
    await _animationController
        .reverse()
        .whenComplete(_tooltipController!.complete);

    _removeEntries();
  }
}
