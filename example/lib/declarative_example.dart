import 'package:flutter/material.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

/// Example showing declarative usage of the tutorial package
class DeclarativeExample extends StatefulWidget {
  const DeclarativeExample({super.key});

  @override
  State<DeclarativeExample> createState() => _DeclarativeExampleState();
}

class _DeclarativeExampleState extends State<DeclarativeExample> {
  final GlobalKey _step1Key = GlobalKey();
  final GlobalKey _step2Key = GlobalKey();
  final GlobalKey _step3Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TutorialBuilder(
      config: const TutorialConfig(
        showStepIndicator: true,
        stepIndicatorStyle: StepIndicatorStyle.progress,
        stepIndicatorPosition: StepIndicatorPosition.bottom,
        defaultAnimationDuration: Duration(milliseconds: 400),
      ),
      autoStart: false,
      steps: [
        TutorialStep(
          targetKey: _step1Key,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app, size: 32, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                'Step 1: Touch Here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('This is the first interactive element.'),
            ],
          ),
          shape: SpotlightShape.circle,
          borderColor: Colors.blue,
        ),
        TutorialStep(
          targetKey: _step2Key,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swipe, size: 32, color: Colors.green),
              SizedBox(height: 8),
              Text(
                'Step 2: Swipe Action',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Try swiping this card to see more options.'),
            ],
          ),
          shape: SpotlightShape.roundedRectangle,
          borderColor: Colors.green,
          tooltipPosition: TooltipPosition.top,
        ),
        TutorialStep(
          targetKey: _step3Key,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, size: 32, color: Colors.purple),
              SizedBox(height: 8),
              Text(
                'Step 3: All Done!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('You\'ve completed the declarative tutorial!'),
            ],
          ),
          shape: SpotlightShape.rectangle,
          borderColor: Colors.purple,
          useBlurEffect: true,
        ),
      ],
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Declarative tutorial completed!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Declarative Tutorial'),
          actions: [
            IconButton(
              onPressed: () => context.startTutorial(),
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step 1 target
              Container(
                key: _step1Key,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Center(
                  child: Text(
                    'Touch Target 1',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Step 2 target
              Card(
                key: _step2Key,
                elevation: 4,
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe_right, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Swipeable Card',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('This card can be swiped'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Step 3 target
              ElevatedButton(
                key: _step3Key,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {
                  context.stopTutorial();
                },
                child: const Text(
                  'Final Button',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => context.startTutorial(),
                    child: const Text('Start'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.nextTutorialStep(),
                    child: const Text('Next'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.previousTutorialStep(),
                    child: const Text('Previous'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.skipTutorial(),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}