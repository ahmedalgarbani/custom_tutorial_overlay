import 'dart:ui';
import 'package:custom_tutorial_overlay/src/widgets/step_indicator_widget.dart';
import 'package:flutter/material.dart';
import '../controllers/tutorial_controller.dart';
import '../models/tutorial_step.dart';
import '../models/tutorial_config.dart';
import '../painters/tutorial_overlay_painter.dart';
import '../widgets/tutorial_tooltip.dart';

/// Main tutorial overlay widget
class TutorialOverlay extends StatefulWidget {
  final TutorialController controller;
  final Widget child;

  const TutorialOverlay({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.controller.config.defaultAnimationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    widget.controller.addListener(_onTutorialStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTutorialStateChanged);
    _animationController.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onTutorialStateChanged() {
    if (widget.controller.isActive && !_isOverlayVisible) {
      _showOverlay();
    } else if (!widget.controller.isActive && _isOverlayVisible) {
      _hideOverlay();
    } else if (widget.controller.isActive && _isOverlayVisible) {
      _updateOverlay();
    }
  }

  void _showOverlay() {
    if (_isOverlayVisible) return;

    _isOverlayVisible = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _TutorialOverlayContent(
        controller: widget.controller,
        animation: _animation,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideOverlay() {
    if (!_isOverlayVisible) return;

    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOverlayVisible = false;
    });
  }

  void _updateOverlay() {
    if (!_isOverlayVisible) return;
    _overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// The actual overlay content widget
class _TutorialOverlayContent extends StatefulWidget {
  final TutorialController controller;
  final Animation<double> animation;

  const _TutorialOverlayContent({
    required this.controller,
    required this.animation,
  });

  @override
  State<_TutorialOverlayContent> createState() =>
      _TutorialOverlayContentState();
}

class _TutorialOverlayContentState extends State<_TutorialOverlayContent> {
  Rect? _spotlightRect;
  Offset _tooltipPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updatePositions);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePositions());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePositions);
    super.dispose();
  }

  void _updatePositions() {
    final step = widget.controller.currentStep;
    if (step == null) return;

    setState(() {
      _spotlightRect = _calculateSpotlightRect(step);
      _tooltipPosition = _calculateTooltipPosition(step, _spotlightRect);
    });
  }

  Rect? _calculateSpotlightRect(TutorialStep step) {
    if (step.customPosition != null && step.customSize != null) {
      return step.customPosition! & step.customSize!;
    }

    if (step.targetKey?.currentContext == null) return null;

    final renderBox =
        step.targetKey!.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      position.dx - step.padding.left,
      position.dy - step.padding.top,
      size.width + step.padding.horizontal,
      size.height + step.padding.vertical,
    );
  }

  Offset _calculateTooltipPosition(TutorialStep step, Rect? spotlightRect) {
    if (spotlightRect == null) {
      // Center of screen if no spotlight
      final screenSize = MediaQuery.of(context).size;
      return Offset(
        screenSize.width / 2 - 150, // Approximate tooltip width / 2
        screenSize.height / 2 - 100, // Approximate tooltip height / 2
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final tooltipSize = const Size(300, 150); // Approximate size

    Offset position;

    switch (step.tooltipPosition) {
      case TooltipPosition.top:
        position = Offset(
          spotlightRect.center.dx - tooltipSize.width / 2,
          spotlightRect.top - tooltipSize.height - 16,
        );
        break;
      case TooltipPosition.bottom:
        position = Offset(
          spotlightRect.center.dx - tooltipSize.width / 2,
          spotlightRect.bottom + 16,
        );
        break;
      case TooltipPosition.left:
        position = Offset(
          spotlightRect.left - tooltipSize.width - 16,
          spotlightRect.center.dy - tooltipSize.height / 2,
        );
        break;
      case TooltipPosition.right:
        position = Offset(
          spotlightRect.right + 16,
          spotlightRect.center.dy - tooltipSize.height / 2,
        );
        break;
      case TooltipPosition.topLeft:
        position = Offset(
          spotlightRect.left,
          spotlightRect.top - tooltipSize.height - 16,
        );
        break;
      case TooltipPosition.topRight:
        position = Offset(
          spotlightRect.right - tooltipSize.width,
          spotlightRect.top - tooltipSize.height - 16,
        );
        break;
      case TooltipPosition.bottomLeft:
        position = Offset(
          spotlightRect.left,
          spotlightRect.bottom + 16,
        );
        break;
      case TooltipPosition.bottomRight:
        position = Offset(
          spotlightRect.right - tooltipSize.width,
          spotlightRect.bottom + 16,
        );
        break;
      case TooltipPosition.auto:
      default:
        // Auto-position based on available space
        position =
            _calculateAutoPosition(spotlightRect, tooltipSize, screenSize);
        break;
    }

    // Apply custom offset
    position += step.tooltipOffset;

    // Clamp to screen bounds
    position = Offset(
      position.dx.clamp(16.0, screenSize.width - tooltipSize.width - 16),
      position.dy.clamp(16.0, screenSize.height - tooltipSize.height - 16),
    );

    return position;
  }

  Offset _calculateAutoPosition(
      Rect spotlightRect, Size tooltipSize, Size screenSize) {
    // Try bottom first
    if (spotlightRect.bottom + tooltipSize.height + 32 <= screenSize.height) {
      return Offset(
        (spotlightRect.center.dx - tooltipSize.width / 2)
            .clamp(16.0, screenSize.width - tooltipSize.width - 16),
        spotlightRect.bottom + 16,
      );
    }

    // Try top
    if (spotlightRect.top - tooltipSize.height - 16 >= 16) {
      return Offset(
        (spotlightRect.center.dx - tooltipSize.width / 2)
            .clamp(16.0, screenSize.width - tooltipSize.width - 16),
        spotlightRect.top - tooltipSize.height - 16,
      );
    }

    // Try right
    if (spotlightRect.right + tooltipSize.width + 32 <= screenSize.width) {
      return Offset(
        spotlightRect.right + 16,
        (spotlightRect.center.dy - tooltipSize.height / 2)
            .clamp(16.0, screenSize.height - tooltipSize.height - 16),
      );
    }

    // Try left
    if (spotlightRect.left - tooltipSize.width - 16 >= 16) {
      return Offset(
        spotlightRect.left - tooltipSize.width - 16,
        (spotlightRect.center.dy - tooltipSize.height / 2)
            .clamp(16.0, screenSize.height - tooltipSize.height - 16),
      );
    }

    // Fallback to center
    return Offset(
      screenSize.width / 2 - tooltipSize.width / 2,
      screenSize.height / 2 - tooltipSize.height / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.controller.currentStep;
    final config = widget.controller.config;

    if (step == null) return const SizedBox.shrink();

    Widget overlay = _buildOverlayContent(step, config);

    // Add blur effect if enabled
    if (step.useBlurEffect) {
      overlay = BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: step.blurIntensity, sigmaY: step.blurIntensity),
        child: overlay,
      );
    }

    return overlay;
  }

  Widget _buildOverlayContent(TutorialStep step, TutorialConfig config) {
    return GestureDetector(
      onTap: config.allowTapOutsideToClose ? widget.controller.stop : null,
      child: Stack(
        children: [
          // Overlay with spotlight
          Positioned.fill(
            child: CustomPaint(
              painter: TutorialOverlayPainter(
                spotlightRect: _spotlightRect,
                step: step,
                animation: widget.animation,
              ),
            ),
          ),

          // Tooltip
          TutorialTooltip(
            step: step,
            controller: widget.controller,
            position: _tooltipPosition,
            animation: widget.animation,
          ),

          // Step indicator
          if (config.showStepIndicator) _buildStepIndicator(config),

          // Close button
          if (config.customCloseButton != null) _buildCloseButton(config),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(TutorialConfig config) {
    Widget indicator;

    if (config.stepIndicatorBuilder != null) {
      indicator = config.stepIndicatorBuilder!(
        widget.controller.currentStepIndex,
        widget.controller.totalSteps,
      );
    } else {
      indicator = StepIndicatorWidget(
        currentStep: widget.controller.currentStepIndex,
        totalSteps: widget.controller.totalSteps,
        style: config.stepIndicatorStyle,
      );
    }

    return _positionStepIndicator(indicator, config.stepIndicatorPosition);
  }

  Widget _positionStepIndicator(
      Widget indicator, StepIndicatorPosition position) {
    switch (position) {
      case StepIndicatorPosition.top:
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 0,
          right: 0,
          child: Center(child: indicator),
        );
      case StepIndicatorPosition.bottom:
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 0,
          right: 0,
          child: Center(child: indicator),
        );
      case StepIndicatorPosition.topLeft:
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: indicator,
        );
      case StepIndicatorPosition.topRight:
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: indicator,
        );
      case StepIndicatorPosition.bottomLeft:
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 16,
          child: indicator,
        );
      case StepIndicatorPosition.bottomRight:
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          right: 16,
          child: indicator,
        );
    }
  }

  Widget _buildCloseButton(TutorialConfig config) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: GestureDetector(
        onTap: widget.controller.stop,
        child: config.customCloseButton!,
      ),
    );
  }
}
