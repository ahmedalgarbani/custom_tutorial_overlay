import 'package:flutter/material.dart';
import '../models/tutorial_config.dart';

/// Widget that displays the current step indicator
class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final StepIndicatorStyle style;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  final double spacing;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.style = StepIndicatorStyle.dots,
    this.activeColor,
    this.inactiveColor,
    this.size = 8.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.primaryColor;
    final effectiveInactiveColor =
        inactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.3);

    switch (style) {
      case StepIndicatorStyle.dots:
        return _buildDots(effectiveActiveColor, effectiveInactiveColor);

      case StepIndicatorStyle.progress:
        return _buildProgress(effectiveActiveColor, effectiveInactiveColor);

      case StepIndicatorStyle.numbers:
        return _buildNumbers(
            effectiveActiveColor, effectiveInactiveColor, theme);
    }
  }

  Widget _buildDots(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }

  Widget _buildProgress(Color activeColor, Color inactiveColor) {
    final progress = totalSteps > 0 ? (currentStep + 1) / totalSteps : 0.0;

    return Container(
      width: 200,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: inactiveColor,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            color: activeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNumbers(
      Color activeColor, Color inactiveColor, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: activeColor.withOpacity(0.1),
        border: Border.all(color: activeColor.withOpacity(0.3)),
      ),
      child: Text(
        '${currentStep + 1} / $totalSteps',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: activeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
