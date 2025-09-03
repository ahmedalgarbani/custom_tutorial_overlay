import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

void main() {
  group('TutorialController Tests', () {
    late TutorialController controller;

    setUp(() {
      controller = TutorialController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should start with empty steps', () {
      expect(controller.steps.length, 0);
      expect(controller.isActive, false);
      expect(controller.currentStepIndex, 0);
    });

    test('should add steps correctly', () {
      final step = TutorialStep(
        content: const Text('Test'),
      );

      controller.addStep(step);
      expect(controller.steps.length, 1);
      expect(controller.totalSteps, 1);
    });

    test('should add multiple steps correctly', () {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
        TutorialStep(content: const Text('Step 3')),
      ];

      controller.addSteps(steps);
      expect(controller.steps.length, 3);
      expect(controller.totalSteps, 3);
    });

    test('should insert step at correct index', () {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 3')),
      ];
      controller.addSteps(steps);

      final insertStep = TutorialStep(content: const Text('Step 2'));
      controller.insertStep(1, insertStep);

      expect(controller.steps.length, 3);
      expect((controller.steps[1].content as Text).data, 'Step 2');
    });

    test('should remove step at correct index', () {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
        TutorialStep(content: const Text('Step 3')),
      ];
      controller.addSteps(steps);

      controller.removeStep(1);
      expect(controller.steps.length, 2);
      expect((controller.steps[1].content as Text).data, 'Step 3');
    });

    test('should update step correctly', () {
      final step = TutorialStep(content: const Text('Original'));
      controller.addStep(step);

      final updatedStep = TutorialStep(content: const Text('Updated'));
      controller.updateStep(0, updatedStep);

      expect((controller.steps[0].content as Text).data, 'Updated');
    });

    test('should clear all steps', () {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
      ];
      controller.addSteps(steps);

      controller.clearSteps();
      expect(controller.steps.length, 0);
      expect(controller.isActive, false);
    });

    test('should start tutorial correctly', () async {
      final step = TutorialStep(content: const Text('Test'));
      controller.addStep(step);

      await controller.start();
      expect(controller.isActive, true);
      expect(controller.currentStepIndex, 0);
    });

    test('should start tutorial at specific index', () async {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
        TutorialStep(content: const Text('Step 3')),
      ];
      controller.addSteps(steps);

      await controller.start(startIndex: 1);
      expect(controller.isActive, true);
      expect(controller.currentStepIndex, 1);
    });

    test('should stop tutorial correctly', () async {
      final step = TutorialStep(content: const Text('Test'));
      controller.addStep(step);

      await controller.start();
      controller.stop();

      expect(controller.isActive, false);
      expect(controller.currentStepIndex, 0);
    });

    test('should navigate to next step', () async {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
      ];
      controller.addSteps(steps);

      await controller.start();
      await controller.next();

      expect(controller.currentStepIndex, 1);
    });

    test('should navigate to previous step', () async {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
      ];
      controller.addSteps(steps);

      await controller.start(startIndex: 1);
      await controller.previous();

      expect(controller.currentStepIndex, 0);
    });

    test('should go to specific step', () async {
      final steps = [
        TutorialStep(content: const Text('Step 1')),
        TutorialStep(content: const Text('Step 2')),
        TutorialStep(content: const Text('Step 3')),
      ];
      controller.addSteps(steps);

      await controller.start();
      await controller.goToStep(2);

      expect(controller.currentStepIndex, 2);
    });

    test('should handle navigation bounds correctly', () async {
      final step = TutorialStep(content: const Text('Single Step'));
      controller.addStep(step);

      await controller.start();

      expect(controller.hasNextStep, false);
      expect(controller.hasPreviousStep, false);
      expect(controller.isFirstStep, true);
      expect(controller.isLastStep, true);

      // These should not crash or change state
      await controller.next();
      await controller.previous();

      expect(controller.currentStepIndex, 0);
    });

    test('should pause and resume correctly', () async {
      final step = TutorialStep(content: const Text('Test'));
      controller.addStep(step);

      await controller.start();
      controller.pause();

      expect(controller.isPaused, true);
      expect(controller.isActive, true);

      controller.resume();
      expect(controller.isPaused, false);
    });

    test('should handle waitForUserAction correctly', () async {
      bool canProceed = false;
      final step = TutorialStep(
        content: const Text('Wait for user'),
        waitForUserAction: true,
        canProceed: () => canProceed,
      );
      controller.addStep(step);

      await controller.start();

      // Should not proceed when canProceed returns false
      await controller.next();
      expect(controller.currentStepIndex, 0);

      // Should proceed after allowProgression is called
      canProceed = true;
      controller.allowProgression();
      await controller.next();
      expect(controller.isActive, false); // No more steps, so tutorial ends
    });

    test('should trigger callbacks correctly', () async {
      bool onShowCalled = false;
      bool onHideCalled = false;
      bool onCompleteCalled = false;
      bool onSkipCalled = false;
      int stepChangedCount = 0;

      controller = TutorialController(
        onComplete: () => onCompleteCalled = true,
        onSkip: () => onSkipCalled = true,
        onStepChanged: (index) => stepChangedCount++,
      );

      final step = TutorialStep(
        content: const Text('Test'),
        onShow: () => onShowCalled = true,
        onHide: () => onHideCalled = true,
      );
      controller.addStep(step);

      await controller.start();
      expect(onShowCalled, true);

      controller.complete();
      expect(onHideCalled, true);
      expect(onCompleteCalled, true);

      // Test skip
      await controller.start();
      controller.skip();
      expect(onSkipCalled, true);
    });

    test('should handle configuration correctly', () {
      final config = TutorialConfig(
        showStepIndicator: false,
        defaultOverlayColor: Colors.red,
        enableSwipeGestures: true,
      );

      final controllerWithConfig = TutorialController(config: config);

      expect(controllerWithConfig.config.showStepIndicator, false);
      expect(controllerWithConfig.config.defaultOverlayColor, Colors.red);
      expect(controllerWithConfig.config.enableSwipeGestures, true);

      controllerWithConfig.dispose();
    });
  });

  group('TutorialStep Tests', () {
    test('should create step with default values', () {
      const step = TutorialStep(content: Text('Test'));

      expect(step.shape, SpotlightShape.circle);
      expect(step.padding, const EdgeInsets.all(8.0));
      expect(step.borderRadius, 8.0);
      expect(step.borderWidth, 2.0);
      expect(step.showNavigationButtons, true);
      expect(step.waitForUserAction, false);
      expect(step.useBlurEffect, false);
      expect(step.animationDuration, const Duration(milliseconds: 300));
    });

    test('should create step copy with updated values', () {
      const originalStep = TutorialStep(
        content: Text('Original'),
        shape: SpotlightShape.circle,
        borderWidth: 2.0,
      );

      final copiedStep = originalStep.copyWith(
        content: const Text('Updated'),
        shape: SpotlightShape.rectangle,
        borderWidth: 4.0,
      );

      expect((copiedStep.content as Text).data, 'Updated');
      expect(copiedStep.shape, SpotlightShape.rectangle);
      expect(copiedStep.borderWidth, 4.0);
      // Original values should be preserved
      expect(copiedStep.padding, originalStep.padding);
      expect(copiedStep.borderRadius, originalStep.borderRadius);
    });
  });

  group('TutorialConfig Tests', () {
    test('should create config with default values', () {
      const config = TutorialConfig();

      expect(config.defaultOverlayColor, const Color(0x99000000));
      expect(config.defaultBorderWidth, 2.0);
      expect(config.showStepIndicator, true);
      expect(config.stepIndicatorStyle, StepIndicatorStyle.dots);
      expect(config.enableSwipeGestures, false);
      expect(config.barrierDismissible, false);
    });

    test('should create config copy with updated values', () {
      const originalConfig = TutorialConfig(
        showStepIndicator: true,
        enableSwipeGestures: false,
      );

      final copiedConfig = originalConfig.copyWith(
        showStepIndicator: false,
        enableSwipeGestures: true,
        defaultBorderWidth: 5.0,
      );

      expect(copiedConfig.showStepIndicator, false);
      expect(copiedConfig.enableSwipeGestures, true);
      expect(copiedConfig.defaultBorderWidth, 5.0);
      // Original values should be preserved where not updated
      expect(
          copiedConfig.barrierDismissible, originalConfig.barrierDismissible);
    });
  });
}
