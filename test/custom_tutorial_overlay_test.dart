import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

void main() {
  group('TutorialOverlay Widget Tests', () {
    testWidgets('should render child widget', (WidgetTester tester) async {
      final controller = TutorialController();

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialOverlay(
            controller: controller,
            child: const Scaffold(
              body: Text('Test Child'),
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should not show overlay when inactive',
        (WidgetTester tester) async {
      final controller = TutorialController();
      controller.addStep(const TutorialStep(content: Text('Tutorial Step')));

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialOverlay(
            controller: controller,
            child: const Scaffold(
              body: Text('Test Child'),
            ),
          ),
        ),
      );

      // Overlay should not be visible when tutorial is not active
      expect(find.text('Tutorial Step'), findsNothing);

      controller.dispose();
    });

    testWidgets('should show overlay when tutorial starts',
        (WidgetTester tester) async {
      final controller = TutorialController();
      controller.addStep(const TutorialStep(content: Text('Tutorial Step')));

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialOverlay(
            controller: controller,
            child: const Scaffold(
              body: Text('Test Child'),
            ),
          ),
        ),
      );

      // Start tutorial
      await controller.start();
      await tester.pumpAndSettle();

      // Overlay should now be visible
      expect(find.text('Tutorial Step'), findsOneWidget);

      controller.dispose();
    });
  });

  group('TutorialBuilder Widget Tests', () {
    testWidgets('should provide tutorial controller to children',
        (WidgetTester tester) async {
      TutorialController? capturedController;

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            steps: const [
              TutorialStep(content: Text('Step 1')),
            ],
            child: Builder(
              builder: (context) {
                capturedController = context.tutorialController;
                return const Text('Child');
              },
            ),
          ),
        ),
      );

      expect(capturedController, isNotNull);
      expect(capturedController!.totalSteps, 1);
    });

    testWidgets('should auto-start tutorial when configured',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            autoStart: true,
            steps: const [
              TutorialStep(content: Text('Auto-started step')),
            ],
            child: const Scaffold(
              body: Text('Child'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tutorial should auto-start and show overlay
      expect(find.text('Auto-started step'), findsOneWidget);
    });

    testWidgets('should handle step builder correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            stepCount: 2,
            stepBuilder: (context, index) => TutorialStep(
              content: Text('Dynamic Step ${index + 1}'),
            ),
            child: const Text('Child'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify steps were created using builder
      final controller = tester
          .element(find.byType(TutorialBuilder))
          .findAncestorWidgetOfExactType<TutorialScope>()
          ?.controller;

      expect(controller?.totalSteps, 2);
    });
  });

  group('StepIndicatorWidget Tests', () {
    testWidgets('should display dots style indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepIndicatorWidget(
              currentStep: 1,
              totalSteps: 3,
              style: StepIndicatorStyle.dots,
            ),
          ),
        ),
      );

      // Should find 3 dot containers
      expect(find.byType(Container), findsNWidgets(3));
    });

    testWidgets('should display progress style indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepIndicatorWidget(
              currentStep: 1,
              totalSteps: 3,
              style: StepIndicatorStyle.progress,
            ),
          ),
        ),
      );

      // Should find progress container with fractional sized box
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('should display numbers style indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepIndicatorWidget(
              currentStep: 1,
              totalSteps: 3,
              style: StepIndicatorStyle.numbers,
            ),
          ),
        ),
      );

      expect(find.text('2 / 3'), findsOneWidget);
    });
  });

  group('Context Extensions Tests', () {
    testWidgets('should provide context extensions',
        (WidgetTester tester) async {
      bool startCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            steps: const [
              TutorialStep(content: Text('Test Step')),
            ],
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await context.startTutorial();
                    startCalled = true;
                  },
                  child: const Text('Start Tutorial'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Start Tutorial'));
      await tester.pumpAndSettle();

      expect(startCalled, true);
      expect(find.text('Test Step'), findsOneWidget);
    });

    testWidgets('should handle context extensions for navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            steps: const [
              TutorialStep(content: Text('Step 1')),
              TutorialStep(content: Text('Step 2')),
            ],
            autoStart: true,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.nextTutorialStep(),
                      child: const Text('Next'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.previousTutorialStep(),
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.skipTutorial(),
                      child: const Text('Skip'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should start with first step
      expect(find.text('Step 1'), findsOneWidget);

      // Test next
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Step 2'), findsOneWidget);

      // Test previous
      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();
      expect(find.text('Step 1'), findsOneWidget);

      // Test skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('Step 1'), findsNothing);
    });
  });

  group('Integration Tests', () {
    testWidgets('should complete full tutorial flow',
        (WidgetTester tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            steps: const [
              TutorialStep(content: Text('Step 1')),
              TutorialStep(content: Text('Step 2')),
              TutorialStep(content: Text('Step 3')),
            ],
            onComplete: () => completed = true,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => context.startTutorial(),
                  child: const Text('Start'),
                );
              },
            ),
          ),
        ),
      );

      // Start tutorial
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();
      expect(find.text('Step 1'), findsOneWidget);

      // Navigate through steps using Next buttons
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Step 2'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Step 3'), findsOneWidget);

      // Complete tutorial
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(completed, true);
      expect(find.text('Step 3'), findsNothing);
    });

    testWidgets('should handle wait for user action',
        (WidgetTester tester) async {
      bool userActionCompleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: TutorialBuilder(
            steps: [
              TutorialStep(
                content: const Text('Wait for user action'),
                waitForUserAction: true,
                canProceed: () => userActionCompleted,
              ),
              const TutorialStep(content: Text('Final Step')),
            ],
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.startTutorial(),
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        userActionCompleted = true;
                        context.allowTutorialProgression();
                      },
                      child: const Text('Complete Action'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Start tutorial
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();
      expect(find.text('Wait for user action'), findsOneWidget);

      // Try to proceed without completing action (should not work)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Wait for user action'), findsOneWidget);
      expect(find.text('Final Step'), findsNothing);

      // Complete user action
      await tester.tap(find.text('Complete Action'));
      await tester.pumpAndSettle();

      // Now should be able to proceed
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Final Step'), findsOneWidget);
    });
  });
}
