import 'package:flutter/material.dart';

import '../../custom_tutorial_overlay.dart';

/// Configuration for the tutorial overlay
class TutorialConfig {
  /// Default overlay color
  final Color defaultOverlayColor;

  /// Default tooltip background color
  final Color? defaultTooltipBackgroundColor;

  /// Default tooltip text color
  final Color? defaultTooltipTextColor;

  /// Default border color for spotlight
  final Color? defaultBorderColor;

  /// Default border width
  final double defaultBorderWidth;

  /// Default animation duration
  final Duration defaultAnimationDuration;

  /// Default shape for spotlight
  final SpotlightShape defaultShape;

  /// Default padding around highlighted widgets
  final EdgeInsets defaultPadding;

  /// Default border radius
  final double defaultBorderRadius;

  /// Whether to show step indicators
  final bool showStepIndicator;

  /// Step indicator position
  final StepIndicatorPosition stepIndicatorPosition;

  /// Step indicator style
  final StepIndicatorStyle stepIndicatorStyle;

  /// Custom step indicator widget builder
  final Widget Function(int currentStep, int totalSteps)? stepIndicatorBuilder;

  /// Whether to enable swipe gestures for navigation
  final bool enableSwipeGestures;

  /// Whether to allow tapping outside to close
  final bool allowTapOutsideToClose;

  /// Custom close button widget
  final Widget? customCloseButton;

  /// Barrier dismissible
  final bool barrierDismissible;

  /// Navigation button text styles
  final TextStyle? nextButtonTextStyle;
  final TextStyle? previousButtonTextStyle;
  final TextStyle? skipButtonTextStyle;

  /// Navigation button colors
  final Color? nextButtonColor;
  final Color? previousButtonColor;
  final Color? skipButtonColor;

  /// Auto-play configuration
  final Duration? autoPlayDelay;

  const TutorialConfig({
    this.defaultOverlayColor = const Color(0x99000000),
    this.defaultTooltipBackgroundColor,
    this.defaultTooltipTextColor,
    this.defaultBorderColor,
    this.defaultBorderWidth = 2.0,
    this.defaultAnimationDuration = const Duration(milliseconds: 300),
    this.defaultShape = SpotlightShape.circle,
    this.defaultPadding = const EdgeInsets.all(8.0),
    this.defaultBorderRadius = 8.0,
    this.showStepIndicator = true,
    this.stepIndicatorPosition = StepIndicatorPosition.bottom,
    this.stepIndicatorStyle = StepIndicatorStyle.dots,
    this.stepIndicatorBuilder,
    this.enableSwipeGestures = false,
    this.allowTapOutsideToClose = false,
    this.customCloseButton,
    this.barrierDismissible = false,
    this.nextButtonTextStyle,
    this.previousButtonTextStyle,
    this.skipButtonTextStyle,
    this.nextButtonColor,
    this.previousButtonColor,
    this.skipButtonColor,
    this.autoPlayDelay,
  });

  /// Creates a copy of this config with updated properties
  TutorialConfig copyWith({
    Color? defaultOverlayColor,
    Color? defaultTooltipBackgroundColor,
    Color? defaultTooltipTextColor,
    Color? defaultBorderColor,
    double? defaultBorderWidth,
    Duration? defaultAnimationDuration,
    SpotlightShape? defaultShape,
    EdgeInsets? defaultPadding,
    double? defaultBorderRadius,
    bool? showStepIndicator,
    StepIndicatorPosition? stepIndicatorPosition,
    StepIndicatorStyle? stepIndicatorStyle,
    Widget Function(int currentStep, int totalSteps)? stepIndicatorBuilder,
    bool? enableSwipeGestures,
    bool? allowTapOutsideToClose,
    Widget? customCloseButton,
    bool? barrierDismissible,
    TextStyle? nextButtonTextStyle,
    TextStyle? previousButtonTextStyle,
    TextStyle? skipButtonTextStyle,
    Color? nextButtonColor,
    Color? previousButtonColor,
    Color? skipButtonColor,
    Duration? autoPlayDelay,
  }) {
    return TutorialConfig(
      defaultOverlayColor: defaultOverlayColor ?? this.defaultOverlayColor,
      defaultTooltipBackgroundColor:
          defaultTooltipBackgroundColor ?? this.defaultTooltipBackgroundColor,
      defaultTooltipTextColor:
          defaultTooltipTextColor ?? this.defaultTooltipTextColor,
      defaultBorderColor: defaultBorderColor ?? this.defaultBorderColor,
      defaultBorderWidth: defaultBorderWidth ?? this.defaultBorderWidth,
      defaultAnimationDuration:
          defaultAnimationDuration ?? this.defaultAnimationDuration,
      defaultShape: defaultShape ?? this.defaultShape,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      showStepIndicator: showStepIndicator ?? this.showStepIndicator,
      stepIndicatorPosition:
          stepIndicatorPosition ?? this.stepIndicatorPosition,
      stepIndicatorStyle: stepIndicatorStyle ?? this.stepIndicatorStyle,
      stepIndicatorBuilder: stepIndicatorBuilder ?? this.stepIndicatorBuilder,
      enableSwipeGestures: enableSwipeGestures ?? this.enableSwipeGestures,
      allowTapOutsideToClose:
          allowTapOutsideToClose ?? this.allowTapOutsideToClose,
      customCloseButton: customCloseButton ?? this.customCloseButton,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      nextButtonTextStyle: nextButtonTextStyle ?? this.nextButtonTextStyle,
      previousButtonTextStyle:
          previousButtonTextStyle ?? this.previousButtonTextStyle,
      skipButtonTextStyle: skipButtonTextStyle ?? this.skipButtonTextStyle,
      nextButtonColor: nextButtonColor ?? this.nextButtonColor,
      previousButtonColor: previousButtonColor ?? this.previousButtonColor,
      skipButtonColor: skipButtonColor ?? this.skipButtonColor,
      autoPlayDelay: autoPlayDelay ?? this.autoPlayDelay,
    );
  }
}

/// Position of the step indicator
enum StepIndicatorPosition {
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Style of the step indicator
enum StepIndicatorStyle {
  dots,
  progress,
  numbers,
}


