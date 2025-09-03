import 'package:flutter/material.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial Overlay Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const TutorialDemo(),
    );
  }
}

class TutorialDemo extends StatefulWidget {
  const TutorialDemo({super.key});

  @override
  State<TutorialDemo> createState() => _TutorialDemoState();
}

class _TutorialDemoState extends State<TutorialDemo> {
  late TutorialController _tutorialController;

  // Global keys for targeting widgets
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  bool _isUserActionCompleted = false;

  @override
  void initState() {
    super.initState();

    // Create tutorial configuration
    final config = TutorialConfig(
      defaultOverlayColor: Colors.black.withOpacity(0.8),
      showStepIndicator: true,
      stepIndicatorPosition: StepIndicatorPosition.topRight,
      stepIndicatorStyle: StepIndicatorStyle.dots,
      enableSwipeGestures: true,
      nextButtonColor: Colors.blue,
      skipButtonColor: Colors.grey,
    );

    // Create tutorial controller
    _tutorialController = TutorialController(
      config: config,
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutorial completed!')),
        );
      },
      onSkip: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutorial skipped!')),
        );
      },
      onStepChanged: (stepIndex) {
        print('Tutorial step changed to: $stepIndex');
      },
    );

    // Add tutorial steps
    _setupTutorialSteps();
  }

  void _setupTutorialSteps() {
    final steps = [
      // Step 1: Welcome message
      TutorialStep(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Tutorial!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This tutorial will guide you through the main features of this app. Let\'s get started!',
            ),
          ],
        ),
        customPosition: const Offset(50, 100),
        customSize: const Size(300, 200),
        shape: SpotlightShape.roundedRectangle,
        borderColor: Colors.blue,
        borderWidth: 3.0,
        tooltipPosition: TooltipPosition.bottom,
        animationDuration: const Duration(milliseconds: 500),
      ),

      // Step 2: Menu button
      TutorialStep(
        targetKey: _menuKey,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Navigation Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Tap this menu button to access navigation options.'),
          ],
        ),
        shape: SpotlightShape.circle,
        padding: const EdgeInsets.all(12),
        borderColor: Colors.green,
        tooltipPosition: TooltipPosition.bottom,
        onShow: () => print('Showing menu step'),
      ),

      // Step 3: Card with user interaction
      TutorialStep(
        targetKey: _cardKey,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                'This card shows important information. Try tapping it!'),
            const SizedBox(height: 12),
            if (!_isUserActionCompleted)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '👆 Tap the card to continue',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        shape: SpotlightShape.roundedRectangle,
        borderColor: Colors.orange,
        tooltipPosition: TooltipPosition.right,
        waitForUserAction: true,
        canProceed: () => _isUserActionCompleted,
      ),

      // Step 4: Floating Action Button
      TutorialStep(
        targetKey: _fabKey,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Action Button',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                'Use this button to add new items or perform the main action.'),
          ],
        ),
        shape: SpotlightShape.circle,
        padding: const EdgeInsets.all(16),
        borderColor: Colors.red,
        tooltipPosition: TooltipPosition.left,
        useBlurEffect: true,
        blurIntensity: 3.0,
      ),

      // Step 5: Custom button with custom navigation
      TutorialStep(
        targetKey: _buttonKey,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tutorial Complete!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('You\'ve successfully completed the tutorial. Well done!'),
          ],
        ),
        shape: SpotlightShape.rectangle,
        borderColor: Colors.purple,
        tooltipPosition: TooltipPosition.top,
        customNextButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Finish',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];

    _tutorialController.addSteps(steps);
  }

  @override
  void dispose() {
    _tutorialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TutorialOverlay(
      controller: _tutorialController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tutorial Demo'),
          leading: IconButton(
            key: _menuKey,
            icon: const Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu pressed!')),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _tutorialController.start(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Interactive card
              Card(
                key: _cardKey,
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isUserActionCompleted = true;
                    });
                    _tutorialController.allowProgression();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Card tapped! You can now continue.')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.info, size: 48, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text(
                          'Interactive Tutorial Card',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isUserActionCompleted
                              ? 'Great! You\'ve interacted with this card.'
                              : 'Tap me during the tutorial!',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tutorial control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _tutorialController.start(),
                    child: const Text('Start Tutorial'),
                  ),
                  ElevatedButton(
                    key: _buttonKey,
                    onPressed: () {
                      setState(() {
                        _isUserActionCompleted = false;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tutorial status
              ListenableBuilder(
                listenable: _tutorialController,
                builder: (context, child) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tutorial Status',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Active: ${_tutorialController.isActive}'),
                          Text(
                              'Current Step: ${_tutorialController.currentStepIndex + 1}/${_tutorialController.totalSteps}'),
                          Text('Is Paused: ${_tutorialController.isPaused}'),
                          if (_tutorialController.isActive) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: _tutorialController.hasPreviousStep
                                      ? () => _tutorialController.previous()
                                      : null,
                                  child: const Text('Previous'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _tutorialController.hasNextStep
                                      ? () => _tutorialController.next()
                                      : null,
                                  child: const Text('Next'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _tutorialController.skip(),
                                  child: const Text('Skip'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: _fabKey,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('FAB pressed!')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
