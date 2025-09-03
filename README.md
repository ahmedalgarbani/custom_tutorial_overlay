# Custom Tutorial Overlay

A highly customizable tutorial overlay package for Flutter that provides step-by-step walkthroughs with spotlight effects, blur/dim backgrounds, and comprehensive navigation controls.

## Features

✅ **Fully Customizable UI**: Customize tooltip content, shapes, colors, padding, and animations  
✅ **Spotlight Effects**: Circle, rounded rectangle, and rectangle shapes with customizable borders  
✅ **Background Effects**: Choose between dim overlay or blur effects  
✅ **Step Navigation**: "Next", "Previous", and "Skip" buttons with full customization  
✅ **Async Step Progression**: Wait for user actions before allowing progression  
✅ **Widget Targeting**: Use GlobalKeys to highlight specific widgets  
✅ **Dual API**: Both declarative and imperative approaches  
✅ **Theme Adaptation**: Automatic light/dark mode support  
✅ **Animated Transitions**: Smooth animations between steps  
✅ **Step Indicators**: Dots, progress bar, or number indicators  
✅ **Cross-Platform**: Supports mobile and web  
✅ **Null Safety**: Full null safety support  

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  custom_tutorial_overlay: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Quick Start

### Imperative Usage

```dart
import 'package:flutter/material.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TutorialController _tutorialController;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    
    // Create tutorial controller
    _tutorialController = TutorialController(
      config: const TutorialConfig(
        showStepIndicator: true,
        stepIndicatorStyle: StepIndicatorStyle.dots,
      ),
      onComplete: () => print('Tutorial completed!'),
    );

    // Add tutorial steps
    _tutorialController.addSteps([
      TutorialStep(
        targetKey: _buttonKey,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('This button does something important.'),
          ],
        ),
        shape: SpotlightShape.circle,
        borderColor: Colors.blue,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TutorialOverlay(
        controller: _tutorialController,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tutorial Demo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.help),
                onPressed: () => _tutorialController.start(),
              ),
            ],
          ),
          body: Center(
            child: ElevatedButton(
              key: _buttonKey,
              onPressed: () => print('Button pressed!'),
              child: const Text('Important Button'),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Declarative Usage

```dart
import 'package:flutter/material.dart';
import 'package:custom_tutorial_overlay/custom_tutorial_overlay.dart';

class DeclarativeExample extends StatelessWidget {
  final GlobalKey _targetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TutorialBuilder(
      config: const TutorialConfig(
        showStepIndicator: true,
        stepIndicatorStyle: StepIndicatorStyle.progress,
      ),
      autoStart: false,
      steps: [
        TutorialStep(
          targetKey: _targetKey,
          content: const Text('This is a declarative tutorial step!'),
          shape: SpotlightShape.roundedRectangle,
          borderColor: Colors.green,
        ),
      ],
      onComplete: () => print('Declarative tutorial completed!'),
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
        body: Center(
          child: Container(
            key: _targetKey,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Target Widget'),
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### TutorialStep

The `TutorialStep` class defines individual steps in your tutorial:

```dart
TutorialStep(
  // Widget targeting
  targetKey: GlobalKey(),              // Target widget using GlobalKey
  customPosition: Offset(100, 200),    // Custom position if no targetKey
  customSize: Size(150, 100),          // Custom size if no targetKey
  
  // Content
  content: Widget,                     // Content to display in tooltip
  
  // Spotlight appearance
  shape: SpotlightShape.circle,        // circle, roundedRectangle, rectangle
  padding: EdgeInsets.all(8),          // Padding around target widget
  borderRadius: 8.0,                   // Corner radius for rounded rectangle
  borderColor: Colors.blue,            // Border color
  borderWidth: 2.0,                    // Border width
  
  // Background
  overlayColor: Colors.black54,        // Overlay color
  useBlurEffect: false,                // Use blur instead of dim
  blurIntensity: 5.0,                  // Blur intensity
  
  // Tooltip appearance
  tooltipBackgroundColor: Colors.white,
  tooltipTextColor: Colors.black,
  tooltipPosition: TooltipPosition.auto,
  tooltipOffset: Offset.zero,
  tooltipMaxWidth: 300.0,
  
  // Navigation
  showNavigationButtons: true,
  customNextButton: Widget,
  customPreviousButton: Widget,
  customSkipButton: Widget,
  
  // Behavior
  waitForUserAction: false,            // Wait for user interaction
  canProceed: () => bool,              // Custom condition for progression
  animationDuration: Duration(milliseconds: 300),
  
  // Callbacks
  onShow: () => print('Step shown'),
  onHide: () => print('Step hidden'),
)
```

### TutorialConfig

Configure global tutorial settings:

```dart
TutorialConfig(
  // Default appearance
  defaultOverlayColor: Colors.black54,
  defaultTooltipBackgroundColor: Colors.white,
  defaultTooltipTextColor: Colors.black,
  defaultBorderColor: Colors.blue,
  defaultBorderWidth: 2.0,
  defaultAnimationDuration: Duration(milliseconds: 300),
  defaultShape: SpotlightShape.circle,
  defaultPadding: EdgeInsets.all(8),
  defaultBorderRadius: 8.0,
  
  // Step indicator
  showStepIndicator: true,
  stepIndicatorPosition: StepIndicatorPosition.bottom,
  stepIndicatorStyle: StepIndicatorStyle.dots,
  stepIndicatorBuilder: (currentStep, totalSteps) => Widget,
  
  // Interaction
  enableSwipeGestures: false,
  allowTapOutsideToClose: false,
  barrierDismissible: false,
  
  // Buttons
  nextButtonColor: Colors.blue,
  previousButtonColor: Colors.grey,
  skipButtonColor: Colors.grey,
  nextButtonTextStyle: TextStyle(),
  previousButtonTextStyle: TextStyle(),
  skipButtonTextStyle: TextStyle(),
  
  // Auto-play
  autoPlayDelay: Duration(seconds: 3),
)
```

### TutorialController

Control tutorial programmatically:

```dart
final controller = TutorialController();

// Step management
controller.addStep(step);
controller.addSteps([step1, step2, step3]);
controller.insertStep(1, step);
controller.removeStep(1);
controller.updateStep(1, newStep);
controller.clearSteps();

// Tutorial control
await controller.start(startIndex: 0);
controller.stop();
controller.pause();
controller.resume();

// Navigation
await controller.next();
await controller.previous();
await controller.goToStep(2);
controller.skip();
controller.complete();

// State
bool isActive = controller.isActive;
bool isPaused = controller.isPaused;
int currentStep = controller.currentStepIndex;
int totalSteps = controller.totalSteps;
bool hasNext = controller.hasNextStep;
bool hasPrevious = controller.hasPreviousStep;

// For waitForUserAction steps
controller.allowProgression();
```

### Context Extensions

When using `TutorialBuilder`, you get convenient context extensions:

```dart
// Start tutorial
context.startTutorial(startIndex: 0);

// Navigation
context.nextTutorialStep();
context.previousTutorialStep();
context.goToTutorialStep(2);

// Control
context.stopTutorial();
context.skipTutorial();
context.allowTutorialProgression();

// Get controller
TutorialController? controller = context.tutorialController;
```

## Advanced Features

### Waiting for User Actions

Create interactive tutorials that wait for user input:

```dart
TutorialStep(
  targetKey: _cardKey,
  content: const Text('Tap this card to continue'),
  waitForUserAction: true,
  canProceed: () => _userHasTappedCard,
)
```

### Custom Step Indicators

Provide your own step indicator widget:

```dart
TutorialConfig(
  stepIndicatorBuilder: (currentStep, totalSteps) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$currentStep/$totalSteps'),
    );
  },
)
```

### Custom Positioning

Position tooltips without targeting specific widgets:

```dart
TutorialStep(
  customPosition: Offset(100, 200),
  customSize: Size(150, 100),
  content: Text('Custom positioned tooltip'),
)
```

### Theme Adaptation

The package automatically adapts to your app's theme:

```dart
// Light theme
ThemeData.light()

// Dark theme  
ThemeData.dark()

// Custom colors will be automatically adjusted
```

### Blur Effects

Use blur effects instead of dim overlay:

```dart
TutorialStep(
  targetKey: _key,
  content: Text('Blurred background'),
  useBlurEffect: true,
  blurIntensity: 5.0,
)
```

## Testing

The package includes comprehensive test coverage. Run tests with:

```bash
flutter test
```

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

### 1.0.0
- Initial release
- Full tutorial overlay functionality
- Customizable spotlight effects
- Step navigation and indicators
- Async step progression
- Theme adaptation
- Cross-platform support