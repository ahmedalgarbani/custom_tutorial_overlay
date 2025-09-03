import 'package:flutter/material.dart';

/// Defines the shape of the spotlight
enum SpotlightShape {
  circle,
  roundedRectangle,
  rectangle,
}

/// Represents a single step in the tutorial
class TutorialStep {
  /// The global key of the widget to highlight
  final GlobalKey? targetKey;

  /// Custom position for the spotlight (if targetKey is not provided)
  final Offset? customPosition;

  /// Custom size for the spotlight (if targetKey is not provided)
  final Size? customSize;

  /// The content to display in the tooltip
  final Widget content;

  /// Shape of the spotlight
  final SpotlightShape shape;

  /// Padding around the highlighted widget
  final EdgeInsets padding;

  /// Corner radius for rounded rectangle shape
  final double borderRadius;

  /// Color of the spotlight border
  final Color? borderColor;

  /// Width of the spotlight border
  final double borderWidth;

  /// Background color of the overlay
  final Color overlayColor;

  /// Tooltip background color
  final Color? tooltipBackgroundColor;

  /// Tooltip text color
  final Color? tooltipTextColor;

  /// Position of the tooltip relative to the spotlight
  final TooltipPosition tooltipPosition;

  /// Custom tooltip offset
  final Offset tooltipOffset;

  /// Maximum width of the tooltip
  final double? tooltipMaxWidth;

  /// Whether to show navigation buttons
  final bool showNavigationButtons;

  /// Custom next button widget
  final Widget? customNextButton;

  /// Custom previous button widget
  final Widget? customPreviousButton;

  /// Custom skip button widget
  final Widget? customSkipButton;

  /// Callback when this step is shown
  final VoidCallback? onShow;

  /// Callback when this step is hidden
  final VoidCallback? onHide;

  /// Whether this step should wait for user action before allowing progression
  final bool waitForUserAction;

  /// Custom validator to check if the step can proceed
  final bool Function()? canProceed;

  /// Animation duration for this step
  final Duration animationDuration;

  /// Whether to use blur effect instead of dim
  final bool useBlurEffect;

  /// Blur intensity (only used if useBlurEffect is true)
  final double blurIntensity;

  const TutorialStep({
    this.targetKey,
    this.customPosition,
    this.customSize,
    required this.content,
    this.shape = SpotlightShape.circle,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderWidth = 2.0,
    this.overlayColor = const Color(0x99000000),
    this.tooltipBackgroundColor,
    this.tooltipTextColor,
    this.tooltipPosition = TooltipPosition.auto,
    this.tooltipOffset = Offset.zero,
    this.tooltipMaxWidth,
    this.showNavigationButtons = true,
    this.customNextButton,
    this.customPreviousButton,
    this.customSkipButton,
    this.onShow,
    this.onHide,
    this.waitForUserAction = false,
    this.canProceed,
    this.animationDuration = const Duration(milliseconds: 300),
    this.useBlurEffect = false,
    this.blurIntensity = 5.0,
  });

  /// Creates a copy of this step with updated properties
  TutorialStep copyWith({
    GlobalKey? targetKey,
    Offset? customPosition,
    Size? customSize,
    Widget? content,
    SpotlightShape? shape,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? overlayColor,
    Color? tooltipBackgroundColor,
    Color? tooltipTextColor,
    TooltipPosition? tooltipPosition,
    Offset? tooltipOffset,
    double? tooltipMaxWidth,
    bool? showNavigationButtons,
    Widget? customNextButton,
    Widget? customPreviousButton,
    Widget? customSkipButton,
    VoidCallback? onShow,
    VoidCallback? onHide,
    bool? waitForUserAction,
    bool Function()? canProceed,
    Duration? animationDuration,
    bool? useBlurEffect,
    double? blurIntensity,
  }) {
    return TutorialStep(
      targetKey: targetKey ?? this.targetKey,
      customPosition: customPosition ?? this.customPosition,
      customSize: customSize ?? this.customSize,
      content: content ?? this.content,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      overlayColor: overlayColor ?? this.overlayColor,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      tooltipTextColor: tooltipTextColor ?? this.tooltipTextColor,
      tooltipPosition: tooltipPosition ?? this.tooltipPosition,
      tooltipOffset: tooltipOffset ?? this.tooltipOffset,
      tooltipMaxWidth: tooltipMaxWidth ?? this.tooltipMaxWidth,
      showNavigationButtons:
          showNavigationButtons ?? this.showNavigationButtons,
      customNextButton: customNextButton ?? this.customNextButton,
      customPreviousButton: customPreviousButton ?? this.customPreviousButton,
      customSkipButton: customSkipButton ?? this.customSkipButton,
      onShow: onShow ?? this.onShow,
      onHide: onHide ?? this.onHide,
      waitForUserAction: waitForUserAction ?? this.waitForUserAction,
      canProceed: canProceed ?? this.canProceed,
      animationDuration: animationDuration ?? this.animationDuration,
      useBlurEffect: useBlurEffect ?? this.useBlurEffect,
      blurIntensity: blurIntensity ?? this.blurIntensity,
    );
  }
}

/// Defines the position of the tooltip relative to the spotlight
enum TooltipPosition {
  auto,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
