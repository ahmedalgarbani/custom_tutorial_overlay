import 'package:flutter/material.dart';
import '../controllers/tutorial_controller.dart';
import '../models/tutorial_step.dart';
import '../models/tutorial_config.dart';

/// Builder function for declarative tutorial steps
typedef TutorialStepBuilder = TutorialStep Function(
    BuildContext context, int index);

/// Declarative widget for defining tutorials
class TutorialBuilder extends StatefulWidget {
  /// List of tutorial steps
  final List<TutorialStep>? steps;

  /// Builder function for creating steps dynamically
  final TutorialStepBuilder? stepBuilder;

  /// Number of steps (required if using stepBuilder)
  final int? stepCount;

  /// Tutorial configuration
  final TutorialConfig? config;

  /// Auto-start the tutorial
  final bool autoStart;

  /// Starting step index
  final int startIndex;

  /// Callback when tutorial completes
  final VoidCallback? onComplete;

  /// Callback when tutorial is skipped
  final VoidCallback? onSkip;

  /// Callback when step changes
  final void Function(int stepIndex)? onStepChanged;

  /// Child widget
  final Widget child;

  const TutorialBuilder({
    super.key,
    this.steps,
    this.stepBuilder,
    this.stepCount,
    this.config,
    this.autoStart = false,
    this.startIndex = 0,
    this.onComplete,
    this.onSkip,
    this.onStepChanged,
    required this.child,
  }) : assert(
          (steps != null) || (stepBuilder != null && stepCount != null),
          'Either provide steps directly or use stepBuilder with stepCount',
        );

  @override
  State<TutorialBuilder> createState() => _TutorialBuilderState();
}

class _TutorialBuilderState extends State<TutorialBuilder> {
  late TutorialController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TutorialController(
      config: widget.config,
      onComplete: widget.onComplete,
      onSkip: widget.onSkip,
      onStepChanged: widget.onStepChanged,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupSteps();
      if (widget.autoStart) {
        _controller.start(startIndex: widget.startIndex);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setupSteps() {
    if (widget.steps != null) {
      _controller.addSteps(widget.steps!);
    } else if (widget.stepBuilder != null && widget.stepCount != null) {
      final steps = List.generate(
        widget.stepCount!,
        (index) => widget.stepBuilder!(context, index),
      );
      _controller.addSteps(steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TutorialScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

/// Inherited widget that provides the tutorial controller to descendants
class TutorialScope extends InheritedWidget {
  final TutorialController controller;

  const TutorialScope({
    super.key,
    required this.controller,
    required super.child,
  });

  /// Gets the tutorial controller from the widget tree
  static TutorialController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TutorialScope>()
        ?.controller;
  }

  /// Gets the tutorial controller from the widget tree (throws if not found)
  static TutorialController controllerOf(BuildContext context) {
    final controller = of(context);
    if (controller == null) {
      throw FlutterError(
        'TutorialScope.controllerOf() called with a context that does not contain a TutorialScope.\n'
        'No TutorialScope ancestor could be found starting from the context that was passed to TutorialScope.controllerOf().\n'
        'This usually happens when the context comes from a widget above the TutorialScope.\n'
        'To fix this, make sure to wrap your app or the relevant part with TutorialBuilder or provide a TutorialScope.',
      );
    }
    return controller;
  }

  @override
  bool updateShouldNotify(TutorialScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Extension methods for easier tutorial control
extension TutorialExtensions on BuildContext {
  /// Gets the tutorial controller from context
  TutorialController? get tutorialController => TutorialScope.of(this);

  /// Starts the tutorial
  Future<void> startTutorial({int? startIndex}) async {
    final controller = tutorialController;
    if (controller != null) {
      await controller.start(startIndex: startIndex);
    }
  }

  /// Stops the tutorial
  void stopTutorial() {
    tutorialController?.stop();
  }

  /// Goes to next tutorial step
  Future<void> nextTutorialStep() async {
    await tutorialController?.next();
  }

  /// Goes to previous tutorial step
  Future<void> previousTutorialStep() async {
    await tutorialController?.previous();
  }

  /// Skips the tutorial
  void skipTutorial() {
    tutorialController?.skip();
  }

  /// Goes to a specific tutorial step
  Future<void> goToTutorialStep(int index) async {
    await tutorialController?.goToStep(index);
  }

  /// Allows progression for waitForUserAction steps
  void allowTutorialProgression() {
    tutorialController?.allowProgression();
  }
}
