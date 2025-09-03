import 'package:custom_tutorial_overlay/src/models/tutorial_config.dart';
import 'package:flutter/material.dart';
import '../models/tutorial_step.dart';
import '../controllers/tutorial_controller.dart';

/// Widget that displays the tooltip content with navigation controls
class TutorialTooltip extends StatelessWidget {
  final TutorialStep step;
  final TutorialController controller;
  final Offset position;
  final Animation<double> animation;

  const TutorialTooltip({
    super.key,
    required this.step,
    required this.controller,
    required this.position,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = step.tooltipBackgroundColor ??
        (isDark ? const Color(0xFF2D2D2D) : Colors.white);

    final textColor =
        step.tooltipTextColor ?? (isDark ? Colors.white : Colors.black);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Positioned(
              left: position.dx,
              top: position.dy,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: step.tooltipMaxWidth ??
                      MediaQuery.of(context).size.width * 0.8,
                ),
                child: Material(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: DefaultTextStyle(
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Content
                          step.content,

                          // Navigation buttons
                          if (step.showNavigationButtons) ...[
                            const SizedBox(height: 16),
                            _buildNavigationButtons(context, theme),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ThemeData theme) {
    final config = controller.config;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip button (left side)
        _buildSkipButton(config, theme),

        // Navigation buttons (right side)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous button
            if (controller.hasPreviousStep) _buildPreviousButton(config, theme),

            if (controller.hasPreviousStep && controller.hasNextStep)
              const SizedBox(width: 8),

            // Next/Finish button
            _buildNextButton(config, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildSkipButton(TutorialConfig config, ThemeData theme) {
    if (step.customSkipButton != null) {
      return GestureDetector(
        onTap: controller.skip,
        child: step.customSkipButton!,
      );
    }

    return TextButton(
      onPressed: controller.skip,
      style: TextButton.styleFrom(
        foregroundColor: config.skipButtonColor ??
            theme.colorScheme.onSurface.withOpacity(0.6),
        textStyle: config.skipButtonTextStyle ?? theme.textTheme.bodyMedium,
      ),
      child: const Text('Skip'),
    );
  }

  Widget _buildPreviousButton(TutorialConfig config, ThemeData theme) {
    if (step.customPreviousButton != null) {
      return GestureDetector(
        onTap: controller.previous,
        child: step.customPreviousButton!,
      );
    }

    return TextButton(
      onPressed: controller.previous,
      style: TextButton.styleFrom(
        foregroundColor: config.previousButtonColor ??
            theme.colorScheme.onSurface.withOpacity(0.8),
        textStyle: config.previousButtonTextStyle ?? theme.textTheme.bodyMedium,
      ),
      child: const Text('Previous'),
    );
  }

  Widget _buildNextButton(TutorialConfig config, ThemeData theme) {
    final isLastStep = controller.isLastStep;
    final buttonText = isLastStep ? 'Finish' : 'Next';
    final onPressed = isLastStep ? controller.complete : controller.next;

    // Check if step is waiting for user action and can't proceed
    final canProceed =
        step.waitForUserAction ? (step.canProceed?.call() ?? false) : true;

    if (step.customNextButton != null) {
      return GestureDetector(
        onTap: canProceed ? onPressed : null,
        child: Opacity(
          opacity: canProceed ? 1.0 : 0.5,
          child: step.customNextButton!,
        ),
      );
    }

    return ElevatedButton(
      onPressed: canProceed ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.nextButtonColor ?? theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        textStyle: config.nextButtonTextStyle ?? theme.textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
